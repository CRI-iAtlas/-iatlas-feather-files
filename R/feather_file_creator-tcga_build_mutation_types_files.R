tcga_build_mutation_types_files <- function() {
  create_global_synapse_connection()

  get_type <- function() {
    cat(crayon::magenta(paste0("Build tcga mutation types.")), fill = TRUE)

    mutation_types <- dplyr::tibble(name = "driver_mutation", display = "Driver Mutation")

    return(mutation_types)
  }

  .GlobalEnv$driver_mutation <- iatlas.data::synapse_store_feather_file(
    get_type(),
    "driver_mutation_mutation_type.feather",
    "syn22131052"
  )

  ### Clean up ###
  # Data
  rm(driver_mutation, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
