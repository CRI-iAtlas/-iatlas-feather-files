tcga_build_tags_to_tags_files <- function() {

  iatlas.data::create_global_synapse_connection()

  get_tags_to_tags <- function() {

    all_tags <- "syn22140514" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.)

    tags1 <- all_tags %>%
      dplyr::select(
        "tag" = "FeatureValue",
        "related_tag" = "sample_group"
      ) %>%
      dplyr::mutate(related_tag =
        dplyr::if_else(
          related_tag == "Study",
          "TCGA_Study",
          dplyr::if_else(
            related_tag == "Subtype_Immune_Model_Based",
            "Immune_Subtype",
            "TCGA_Subtype"
          )
        )
      )

    tags2 <- all_tags %>%
      dplyr::filter(sample_group == "Subtype_Curated_Malta_Noushmehr_et_al") %>%
      dplyr::select(
        "tag" = "FeatureValue",
        "related_tag" = "TCGA Studies"
      ) %>%
      dplyr::mutate("related_tag" = paste0(related_tag, " Subtypes"))

    tags_to_tags <-
      dplyr::bind_rows(tags1, tags2) %>%
      dplyr::add_row(
        "tag" = c("Immune_Subtype", "TCGA_Subtype", "TCGA_Study"),
        "related_tag" = c("TCGA", "TCGA", "TCGA")
      )

    return(tags_to_tags)
  }

  .GlobalEnv$tcga_tags_to_tags <- iatlas.data::synapse_store_feather_file(
    get_tags_to_tags(),
    "tcga_tags_to_tags.feather",
    "syn22125980"
  )

  ### Clean up ###
  # Data
  rm(tcga_tags_to_tags, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
