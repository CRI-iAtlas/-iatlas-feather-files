pcawg_build_cellimage_nodes_to_tags_files <- function() {

  immune_subtype_nodes_to_tags <- "syn23538626" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes_to_tags,
    "pcawg_cellimage_immune_subtype_nodes_to_tags.feather",
    "syn26023432"
  )

  pcawg_study_nodes_to_tags <- "syn23538628" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    pcawg_study_nodes_to_tags,
    "pcawg_cellimage_pcawg_study_nodes_to_tags.feather",
    "syn26023432"
  )

}
