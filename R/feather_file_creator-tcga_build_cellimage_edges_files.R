tcga_build_cellimage_edges_files <- function() {

  immune_subtype_edges <- "syn23538718" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_edges,
    "tcga_cellimage_immune_subtype_edges.feather",
    "syn22126181"
  )

  tcga_study_edges <- "syn23538720" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network")

  iatlas.data::synapse_store_feather_file(
    tcga_study_edges,
    "tcga_cellimage_tcga_study_edges.feather",
    "syn22126181"
  )

  tcga_subtype_edges <- "syn23538725" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network")

  iatlas.data::synapse_store_feather_file(
    tcga_subtype_edges,
    "tcga_cellimage_tcga_subtype_edges.feather",
    "syn22126181"
  )

}
