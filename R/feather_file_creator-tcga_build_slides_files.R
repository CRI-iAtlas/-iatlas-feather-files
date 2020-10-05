tcga_build_slides_files <- function() {

  iatlas.data::create_global_synapse_connection()

  get_slides <- function() {

    slides <- "syn22128019" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      arrow::read_feather(.) %>%
      dplyr::select(
        "patient_barcode" = "ParticipantBarcode",
        "name" = "Slide"
      ) %>%
      tidyr::drop_na()

    return(slides)
  }

  .GlobalEnv$tcga_slides <- iatlas.data::synapse_store_feather_file(
    get_slides(),
    "tcga_slides.feather",
    "syn22140512"
  )

  ### Clean up ###
  # Data
  rm(tcga_slides, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
