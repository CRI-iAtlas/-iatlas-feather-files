pcawg_build_features_files <- function() {

  get_features <- function() {

    cat(crayon::magenta(paste0("Get features")), fill = TRUE)

    features <- iatlas.data::get_pcawg_features_cached()

    return(features)
  }

  .GlobalEnv$pcawg_features <- iatlas.data::synapse_store_feather_file(
    get_features(),
    "pcawg_features.feather",
    "syn22125617"
  )


  ### Clean up ###
  # Data
  rm(pcawg_features, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
