pcawg_build_cellimage_nodes_files <- function() {

  immune_subtype_nodes <- "syn23538626" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "dataset", "x", "y")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes,
    "pcawg_cellimage_immune_subtype_nodes.feather",
    "syn22126180"
  )

  pcawg_study_nodes <- "syn23538628" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "dataset", "x", "y")

  iatlas.data::synapse_store_feather_file(
    pcawg_study_nodes,
    "pcawg_cellimage_pcawg_study_nodes.feather",
    "syn22126180"
  )

}
