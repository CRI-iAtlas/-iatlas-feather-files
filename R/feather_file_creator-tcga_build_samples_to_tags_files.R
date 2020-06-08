tcga_build_samples_to_tags_files <- function() {

  iatlas.data::create_global_synapse_connection()

  get_samples_to_tags <- function() {

    samples_to_tags <- "syn22128019" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
      dplyr::select(
        "sample" = "ParticipantBarcode",
        "Study",
        "Subtype_Immune_Model_Based",
        "Subtype_Curated_Malta_Noushmehr_et_al"
      ) %>%
      dplyr::mutate("dataset" = "TCGA") %>%
      tidyr::pivot_longer(-"sample", values_to = "tag") %>%
      tidyr::drop_na() %>%
      dplyr::select("sample", "tag") %>%
      dplyr::arrange(sample, tag)

    return(samples_to_tags)
  }

  .GlobalEnv$tcga_samples_to_tags <- iatlas.data::synapse_store_feather_file(
    get_samples_to_tags(),
    "tcga_samples_to_tags.feather",
    "syn22125729"
  )


  ### Clean up ###
  # Data
  rm(tcga_samples_to_tags, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
