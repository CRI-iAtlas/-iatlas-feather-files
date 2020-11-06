build_genes <- function(){
  require(magrittr)

  immunomodulators <- "syn23518460" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("entrez") %>%
    tidyr::drop_na() %>%
    dplyr::mutate("gene_type" = "immunomodulator")

  io_targets <- "syn23518486" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("entrez") %>%
    tidyr::drop_na() %>%
    dplyr::mutate("gene_type" = "io_target")

  potential_immunomodulators <- "syn22151532" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Entrez ID") %>%
    tidyr::drop_na() %>%
    dplyr::mutate("gene_type" = "potential_immunomodulator")

  extracellular_network <- "syn23518510" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    tidyr::pivot_longer(dplyr::everything()) %>%
    dplyr::select("entrez" = "value") %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      "entrez" = as.integer(.data$entrez),
      "gene_type" = "extra_cellular_network"
    ) %>%
    tidyr::drop_na()

  cellimage_network <- "syn23518512" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("From", "To") %>%
    tidyr::pivot_longer(dplyr::everything()) %>%
    dplyr::select("entrez" = "value") %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      "entrez" = as.integer(.data$entrez),
      "gene_type" = "cellimage_network"
    ) %>%
    tidyr::drop_na()

  wolf <- "syn22240714" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Genes", "gene_type" = "GeneSet") %>%
    tidyr::drop_na()

  yasin <- "syn22240715" %>%
    iatlas.data::synapse_delimited_id_to_tbl(.) %>%
    dplyr::select("entrez" = "Entrez", "gene_type" = "GeneSet") %>%
    tidyr::drop_na()

  entrez_ids <- "syn22240716" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
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

