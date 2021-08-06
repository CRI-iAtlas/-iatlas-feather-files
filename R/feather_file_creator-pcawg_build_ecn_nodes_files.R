tcga_build_ecn_nodes_files <- function() {

  immune_subtype_nodes <- "syn23538632" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "label", "dataset")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes,
    "pcawg_extracellular_network_immune_subtype_nodes.feather",
    "syn22126180"
  )

  pcawg_study_nodes <- "syn23538635" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "label", "dataset")

  iatlas.data::synapse_store_feather_file(
    pcawg_study_nodes,
    "pcawg_extracellular_network_pcawg_study_nodes.feather",
    "syn22126180"
  )

}
