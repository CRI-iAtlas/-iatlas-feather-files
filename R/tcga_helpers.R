get_tcga_stratified_extracellular_network_nodes_cached <- function() {
  iatlas.data::result_cached(
    "tcga_extracellular_network_nodes",
    iatlas.data::get_tcga_stratified_extracellular_network_nodes()
  )
}

get_tcga_stratified_extracellular_network_edges_cached <- function() {
  iatlas.data::result_cached(
    "get_tcga_extracellular_network_edges",
    iatlas.data::get_tcga_stratified_extracellular_network_edges()
  )
}

get_tcga_copynumber_results_cached <- function() {
  iatlas.data::result_cached(
    "tcga_copynumber_results_synapse",
    iatlas.data::get_tcga_copynumber_results()
  )
}


