build_genes_synapse_table <- function(){
  require(magrittr)

  immunomodulators <- "syn22151531" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "entrez" = "Entrez ID",
      "friendly_name" = "Friendly Name",
      "gene_family" = "Gene Family",
      "super_category" = "Super Category",
      "immune_checkpoint" = "Immune Checkpoint",
      "gene_function" = "Function",,
      "references" = "Reference(s) [PMID]"
    ) %>%
    dplyr::filter(!is.na(entrez)) %>%
    dplyr::mutate(
      "geneset" = "immunomodulator",
      "references" = purrr::map_chr(
        references,
        ~jsonlite::toJSON(unlist(stringr::str_split(.x, " \\| ")))
      )
    )

  io_targets <- "syn22151533" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "entrez" = "Entrez ID",
      "io_landscape_name" = "Friendly Name",
      "pathway" = "Pathway",
      "therapy_type" = "Therapy Type",
      "description" = "Description"
    ) %>%
    dplyr::mutate("geneset" = "io_target", "entrez" = as.integer(entrez))

  potential_immunomodulators <- "syn22151532" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Entrez ID") %>%
    dplyr::mutate("geneset" = "potential_immunomodulator")

  extracellular_network <- "syn21783989" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "hgnc" = "Obj",
      "node_type" = "Type"
    ) %>%
    dplyr::left_join(
      iatlas.data::get_tcga_gene_ids() %>%
        dplyr::mutate_at(dplyr::vars(entrez), as.numeric),
      by = "hgnc"
    ) %>%
    dplyr::select(-"hgnc") %>%
    dplyr::mutate("geneset" = "extra_cellular_network") %>%
    tidyr::drop_na()

  cellimage_network <- "syn21782167" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    tidyr::pivot_longer(-"interaction", values_to = "hgnc") %>%
    dplyr::select("hgnc") %>%
    dplyr::distinct() %>%
    dplyr::left_join(
      iatlas.data::get_tcga_gene_ids() %>%
        dplyr::mutate_at(dplyr::vars(entrez), as.numeric),
      by = "hgnc"
    ) %>%
    dplyr::select("entrez") %>%
    dplyr::mutate("geneset" = "cellimage_network")

  wolf <- "syn22240714" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Genes", "geneset" = "GeneSet")

  yasin <- "syn22240715" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Entrez", "geneset" = "GeneSet")

  genesets <-
    dplyr::bind_rows(
      immunomodulators,
      io_targets,
      potential_immunomodulators,
      wolf,
      yasin,
      extracellular_network,
      cellimage_network
    ) %>%
    dplyr::select(entrez, geneset) %>%
    tidyr::drop_na() %>%
    dplyr::group_by(entrez) %>%
    dplyr::summarise(genesets = jsonlite::toJSON(unique(geneset))) %>%
    dplyr::arrange(entrez)


  entrez_to_hgnc <- "syn22240716" %>%
    iatlas.data::synapse_feather_id_to_tbl() %>%
    dplyr::select("entrez", "hgnc")

  tbl <-
    purrr::reduce(
      .x = list(
        dplyr::select(immunomodulators, -"geneset"),
        dplyr::select(io_targets, -"geneset"),
        dplyr::select(extracellular_network, -"geneset"),
        genesets
      ),
      .f = dplyr::full_join,
      by = "entrez"
    ) %>%
    dplyr::right_join(entrez_to_hgnc, by = "entrez") %>%
    dplyr::select("entrez", "hgnc", "genesets", "references", dplyr::everything())

  iatlas.data::update_synapse_table("syn22151431", tbl)
}

