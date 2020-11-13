tcga_build_ecn_nodes_files <- function() {

  iatlas.data::synapse_store_feather_file(
    get_tcga_extracellular_network_nodes_cached(),
    "tcga_extracellular_network_nodes.feather",
    "syn22126180"
  )
}
