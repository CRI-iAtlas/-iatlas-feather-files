get_tcga_extracellular_network_nodes_cached <- function() {
  iatlas.data::create_global_synapse_connection()
  iatlas.data::result_cached(
    "tcga_extracellular_network_nodes",
    iatlas.data::get_tcga_extracellular_network_nodes()
  )
}

get_tcga_extracellular_network_edges_cached <- function() {
  iatlas.data::create_global_synapse_connection()
  iatlas.data::result_cached(
    "get_tcga_extracellular_network_edges",
    iatlas.data::get_tcga_extracellular_network_edges()
  )
}

get_tcga_cellimage_nodes_cached <- function() {
  iatlas.data::create_global_synapse_connection()
  iatlas.data::result_cached(
    "tcga_cellimage_nodes_synapse",
    iatlas.data::get_tcga_cellimage_nodes()
  )
}

get_tcga_cellimage_edges_cached <- function() {
  iatlas.data::create_global_synapse_connection()
  iatlas.data::result_cached(
    "tcga_cellimage_edges_synapse",
    iatlas.data::get_tcga_cellimage_edges()
  )
}

get_tcga_copynumber_results_cached <- function() {
  iatlas.data::create_global_synapse_connection()
  iatlas.data::result_cached(
    "tcga_copynumber_results_synapse",
    iatlas.data::get_tcga_copynumber_results()
  )
}


