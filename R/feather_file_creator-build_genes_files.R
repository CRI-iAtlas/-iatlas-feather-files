build_genes <- function(){
  require(magrittr)

  immunomodulators <- iatlas.data::synapse_feather_id_to_tbl("syn23518460")
  io_targets <- iatlas.data::synapse_feather_id_to_tbl("syn23518486")

  hgnc_to_entrez <- iatlas.data::synapse_feather_id_to_tbl("syn22240716")

  tbl <-
    purrr::reduce(
      list(immunomodulators, io_targets),
      dplyr::full_join,
      by = "entrez"
    ) %>%
    dplyr::right_join(hgnc_to_entrez, by = "entrez") %>%
    dplyr::select("entrez", "hgnc", dplyr::everything())

  iatlas.data::synapse_store_feather_file(tbl, "genes.feather", "syn22125640")

}

