tcga_build_ecn_edges_files <- function() {

  cat(crayon::magenta(paste0("Get TCGA edges.")), fill = TRUE)

  iatlas.data::synapse_store_feather_file(
    get_tcga_extracellular_network_edges(),
    "tcga_extracellular_network_edges.feather",
    "syn22126181"
  )
}
