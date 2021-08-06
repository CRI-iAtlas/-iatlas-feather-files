tcga_build_ecn_nodes_to_tags_file <- function() {

  stratified_nodes_to_tags <- get_tcga_stratified_extracellular_network_nodes_cached() %>%
    dplyr::select("node" = "name", "tag", "tag_2") %>%
    tidyr::pivot_longer(cols = -"node", values_to = "tag") %>%
    dplyr::select(-"name") %>%
    tidyr::drop_na()

  iatlas.data::synapse_store_feather_file(
    stratified_nodes_to_tags,
    "tcga_extracellular_network_stratified_nodes_to_tags.feather",
    "syn26023432"
  )

  immune_subtype_nodes_to_tags <- "syn23538679" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes_to_tags,
    "tcga_extracellular_network_immune_subtype_nodes_to_tags.feather",
    "syn26023432"
  )

  tcga_study_nodes_to_tags <- "syn23538696" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    tcga_study_nodes_to_tags,
    "tcga_extracellular_network_tcga_study_nodes_to_tags.feather",
    "syn26023432"
  )

  tcga_subtype_nodes_to_tags <- "syn23538712" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    tcga_subtype_nodes_to_tags,
    "tcga_extracellular_network_tcga_subtype_nodes_to_tags.feather",
    "syn26023432"
  )

}
