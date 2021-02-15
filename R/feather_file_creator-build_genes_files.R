build_genes <- function(){
  require(magrittr)

  immunomodulators <- iatlas.data::synapse_feather_id_to_tbl("syn23518460")
  io_targets <-
    iatlas.data::synapse_feather_id_to_tbl("syn22151533") %>%
    dplyr::select(
      "entrez" = "Entrez ID",
      "io_landscape_name" = "Friendly Name",
      "pathway" = "Pathway",
      "therapy_type" = "Therapy Type",
      "description" = "Description"
    ) %>%
    dplyr::group_by(.data$entrez) %>%
    dplyr::mutate("entrez" = as.integer(.data$entrez))

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

