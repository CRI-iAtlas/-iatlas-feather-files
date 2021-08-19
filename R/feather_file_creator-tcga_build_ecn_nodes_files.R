tcga_build_ecn_nodes_files <- function() {

  stratified_nodes <- "syn26067676" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network") %>%
    dplyr::filter(!stringr::str_detect(.data$tag, "NA:")) %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "label", "dataset")

  iatlas.data::synapse_store_feather_file(
    stratified_nodes,
    "tcga_extracellular_network_stratified_nodes.feather",
    "syn22126180"
  )

  immune_subtype_nodes <- "syn23538679" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "label", "dataset")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes,
    "tcga_extracellular_network_immune_subtype_nodes.feather",
    "syn22126180"
  )

  tcga_study_nodes <- "syn23538696" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "label", "dataset")

  iatlas.data::synapse_store_feather_file(
    tcga_study_nodes,
    "tcga_extracellular_network_tcga_study_nodes.feather",
    "syn22126180"
  )

  tcga_subtype_nodes <- "syn23538712" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Extracellular Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "label", "dataset")

  iatlas.data::synapse_store_feather_file(
    tcga_subtype_nodes,
    "tcga_extracellular_network_tcga_subtype_nodes.feather",
    "syn22126180"
  )

}
