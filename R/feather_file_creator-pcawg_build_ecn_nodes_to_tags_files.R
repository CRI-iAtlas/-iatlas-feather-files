tcga_build_ecn_nodes_to_tags_files <- function() {

  immune_subtype_nodes_to_tags <- "syn23538632" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes_to_tags,
    "pcawg_extracellular_network_immune_subtype_nodes_to_tags.feather",
    "syn26023432"
  )

  pcawg_study_nodes_to_tags <- "syn23538635" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    pcawg_study_nodes_to_tags,
    "pcawg_extracellular_network_pcawg_study_nodes_to_tags.feather",
    "syn26023432"
  )

}
