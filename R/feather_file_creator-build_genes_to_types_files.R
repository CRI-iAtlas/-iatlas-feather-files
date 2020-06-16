build_genes <- function(){
  require(magrittr)

  immunomodulators <- "syn22151531" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select( "entrez" = "Entrez ID") %>%
    tidyr::drop_na() %>%
    dplyr::mutate("gene_type" = "immunomodulator")

  io_targets <- "syn22151533" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Entrez ID") %>%
    tidyr::drop_na() %>%
    dplyr::mutate("gene_type" = "io_target", "entrez" = as.integer(entrez))

  potential_immunomodulators <- "syn22151532" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Entrez ID") %>%
    tidyr::drop_na() %>%
    dplyr::mutate("gene_type" = "potential_immunomodulator")

  extracellular_network <- "syn21783989" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("hgnc" = "Obj") %>%
    dplyr::left_join(
      iatlas.data::get_tcga_gene_ids() %>%
        dplyr::mutate_at(dplyr::vars(entrez), as.numeric),
      by = "hgnc"
    ) %>%
    dplyr::select(-"hgnc") %>%
    dplyr::mutate("gene_type" = "extra_cellular_network") %>%
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
    dplyr::mutate("gene_type" = "cellimage_network") %>%
    tidyr::drop_na()

  wolf <- "syn22151547" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Genes", "gene_type" = "GeneSet") %>%
    tidyr::drop_na()

  yasin <- "syn22151548" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Entrez", "gene_type" = "GeneSet") %>%
    tidyr::drop_na()

  entrez_ids <- "syn21788372" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::pull("entrez")

  tbl <-
    dplyr::bind_rows(wolf, yasin) %>%
    dplyr::mutate("gene_type" = stringr::str_replace_all(gene_type, "[ \\.]", "_")) %>%
    dplyr::bind_rows(
      immunomodulators,
      io_targets,
      potential_immunomodulators,
      extracellular_network,
      cellimage_network
    ) %>%
    dplyr::filter(entrez %in% entrez_ids)

  iatlas.data::synapse_store_feather_file(tbl, "genes_to_types.feather", "syn22130912")

}

