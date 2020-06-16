build_genes <- function(){
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
    dplyr::mutate("references" = purrr::map_chr(
      references,
      ~ .x %>%
        stringr::str_split(., " \\| ") %>%
        purrr::map_chr(purrr::pluck(1)) %>%
        stringr::str_c("{", ., "}")
    ))

  io_targets <- "syn22151533" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "entrez" = "Entrez ID",
      "io_landscape_name" = "Friendly Name",
      "pathway" = "Pathway",
      "therapy_type" = "Therapy Type",
      "description" = "Description"
    ) %>%
    dplyr::mutate("entrez" = as.integer(entrez)) %>%
    dplyr::group_by(entrez) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup()


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
    dplyr::select("entrez")

  entrez_to_hgnc <- "syn21788372" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::select("entrez", "hgnc")

  tbl <-
    purrr::reduce(
      list(immunomodulators, io_targets, extracellular_network),
      dplyr::full_join,
      by = "entrez"
    ) %>%
    dplyr::right_join(entrez_to_hgnc, by = "entrez") %>%
    dplyr::select("entrez", "hgnc", "references", dplyr::everything())

  iatlas.data::synapse_store_feather_file(tbl, "genes.feather", "syn22125640")

}

