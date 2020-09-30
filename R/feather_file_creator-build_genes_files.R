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
      "gene_function" = "Function"
    ) %>%
    dplyr::filter(!is.na(entrez))

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

