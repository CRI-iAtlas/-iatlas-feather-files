pcawg_build_ecn_edges_files <- function() {

  immune_subtype_edges <- "syn23538633" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_edges,
    "pcawg_extracellular_network_immune_subtype_edges.feather",
    "syn22126181"
  )

  pcawg_study_edges <- "syn23538636" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network")

  iatlas.data::synapse_store_feather_file(
    pcawg_study_edges,
    "pcawg_extracellular_network_pcawg_study_edges.feather",
    "syn22126181"
  )

}
