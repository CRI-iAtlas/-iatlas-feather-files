tcga_build_gene_types_files <- function() {
  cat_gene_types_status <- function(message) {
    cat(crayon::cyan(paste0(" - ", message)), fill = TRUE)
  }

  get_type <- function() {
    cat(crayon::magenta(paste0("Get tcga gene_type.`")), fill = TRUE)

    cat_gene_types_status("Build gene_types data.")
    gene_types <- dplyr::tibble(
      name = c("extra_cellular_network", "immunomodulator", "io_target"),
      display = c("Extra Cellular Network", "Immunomodulator", "IO Target")
    )

    return(gene_types)
  }

  # Setting these to the GlobalEnv just for development purposes.
  create_global_synapse_connection()

  .GlobalEnv$tcga_gene_types <- iatlas.data::synapse_store_feather_file(
    get_type(),
    "tcga_gene_types.feather",
    "syn22130910"
  )

  ### Clean up ###
  # Data
  rm(tcga_gene_types, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
