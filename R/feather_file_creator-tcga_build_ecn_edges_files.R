tcga_build_ecn_edges_files <- function() {

  stratified_edges <- "syn26067672" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::filter(!stringr::str_detect(.data$name, "NA")) %>%
    dplyr::select("name", "score", "node1", "node2")

  iatlas.data::synapse_store_feather_file(
    stratified_edges,
    "tcga_extracellular_network_stratified_edges.feather",
    "syn22126181"
  )

  immune_subtype_edges <- "syn23538678" %>%
    synapse_feather_id_to_tbl()  %>%
    dplyr::select("name", "score", "node1", "node2")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_edges,
    "tcga_extracellular_network_immune_subtype_edges.feather",
    "syn22126181"
  )

  tcga_study_edges <- "syn23538697" %>%
    synapse_feather_id_to_tbl()  %>%
    dplyr::select("name", "score", "node1", "node2")

  iatlas.data::synapse_store_feather_file(
    tcga_study_edges,
    "tcga_extracellular_network_tcga_study_edges.feather",
    "syn22126181"
  )

  tcga_subtype_edges <- "syn23538713" %>%
    synapse_feather_id_to_tbl()  %>%
    dplyr::select("name", "score", "node1", "node2")

  iatlas.data::synapse_store_feather_file(
    tcga_subtype_edges,
    "tcga_extracellular_network_tcga_subtype_edges.feather",
    "syn22126181"
  )

}
