tcga_build_patients_files <- function() {

  iatlas.data::create_global_synapse_connection()

  get_patients <- function() {

    cat(crayon::magenta(paste0("Get patients.")), fill = TRUE)

    patients <- "syn22128019" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
      dplyr::select(
        "barcode" = "ParticipantBarcode",
        "age" = "age_at_initial_pathologic_diagnosis",
        "ethnicity",
        "gender",
        "height",
        "race",
        "weight"
      ) %>%
      dplyr::arrange(barcode)

    return(patients)
  }

  .GlobalEnv$tcga_patients <- iatlas.data::synapse_store_feather_file(
    get_patients(),
    "tcga_patients.feather",
    "syn22125717"
  )

  ### Clean up ###
  # Data
  rm(tcga_patients, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
