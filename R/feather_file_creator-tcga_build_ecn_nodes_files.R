tcga_build_ecn_nodes_files <- function() {

  get_nodes <- function() {

    cat(crayon::magenta(paste0("Get TCGA nodes.")), fill = TRUE)

    cytokine_nodes <-
      iatlas.data::get_tcga_cytokine_nodes_cached() %>%
      dplyr::mutate("network" = "extracellular_network")

    cellimage_nodes <-
      iatlas.data::get_tcga_cellimage_nodes_cached() %>%
      dplyr::mutate("network" = "cellimage_network")

    nodes <-
      dplyr::bind_rows(cytokine_nodes, cellimage_nodes) %>%
      dplyr::mutate("dataset" = "TCGA")

    return(nodes)
  }

  # Setting these to the GlobalEnv just for development purposes.

  .GlobalEnv$tcga_nodes <- iatlas.data::synapse_store_feather_file(
    get_nodes(),
    "tcga_nodes.feather",
    "syn22126180"
  )

  # Log out of Synapse.
  iatlas.data::synapse_logout()

  ### Clean up ###
  # Data
  rm(tcga_nodes, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
