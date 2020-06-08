tcga_build_samples_files <- function() {

  iatlas.data::create_global_synapse_connection()

  get_samples <- function() {

    cat(crayon::magenta(paste0("Get samples.")), fill = TRUE)

    samples <- "syn22128019" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
      dplyr::select("name" = "ParticipantBarcode") %>%
      dplyr::mutate("patient_barcode" = name) %>%
      dplyr::arrange(name)

    return(samples)
  }

  .GlobalEnv$tcga_samples <- iatlas.data::synapse_store_feather_file(
    get_samples(),
    "tcga_samples.feather",
    "syn22125724"
  )

  ### Clean up ###
  # Data
  rm(tcga_samples, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
