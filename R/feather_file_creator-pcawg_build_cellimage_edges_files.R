pcawg_build_cellimage_edges_files <- function() {

  immune_subtype_edges <- "syn23538627" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_edges,
    "pcawg_cellimage_immune_subtype_edges.feather",
    "syn22126181"
  )

  pcawg_study_edges <- "syn23538630" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network")

  iatlas.data::synapse_store_feather_file(
    pcawg_study_edges,
    "pcawg_cellimage_pcawg_study_edges.feather",
    "syn22126181"
  )

}
