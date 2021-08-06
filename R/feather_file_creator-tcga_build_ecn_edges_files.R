tcga_build_ecn_edges_files <- function() {

  iatlas.data::synapse_store_feather_file(
    get_tcga_stratified_extracellular_network_edges_cached(),
    "tcga_extracellular_network_stratified_edges.feather",
    "syn22126181"
  )

  immune_subtype_edges <- "syn23538678" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_edges,
    "tcga_extracellular_network_immune_subtype_edges.feather",
    "syn22126181"
  )

  tcga_study_edges <- "syn23538697" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network")

  iatlas.data::synapse_store_feather_file(
    tcga_study_edges,
    "tcga_extracellular_network_tcga_study_edges.feather",
    "syn22126181"
  )

  tcga_subtype_edges <- "syn23538713" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network")

  iatlas.data::synapse_store_feather_file(
    tcga_subtype_edges,
    "tcga_extracellular_network_tcga_subtype_edges.feather",
    "syn22126181"
  )

}
