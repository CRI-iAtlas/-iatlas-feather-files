tcga_build_ecn_edges_files <- function() {

  iatlas.data::synapse_store_feather_file(
    get_tcga_extracellular_network_edges_cached(),
    "tcga_extracellular_network_edges.feather",
    "syn22126181"
  )
}
