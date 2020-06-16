tcga_build_tags_to_tags_files <- function() {

  require(magrittr)

  get_tags_to_tags <- function() {

    all_tags <- synapse_feather_id_to_tbl("syn22140514")

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

    tags2 <- tags1 %>%
      dplyr::select("tag") %>%
      dplyr::mutate("related_tag" = "group")

    tags3 <- tags1 %>%
      dplyr::select("tag" = "related_tag") %>%
      dplyr::distinct() %>%
      dplyr::mutate("related_tag" = "parent_group")


    tags4 <- all_tags %>%
      dplyr::filter(sample_group == "Subtype_Curated_Malta_Noushmehr_et_al") %>%
      dplyr::select(
        "tag" = "FeatureValue",
        "related_tag" = "TCGA Studies"
      ) %>%
      dplyr::mutate("related_tag" = paste0(related_tag, " Subtypes"))

    tags5 <- tags4 %>%
      dplyr::select("tag" = "related_tag") %>%
      dplyr::distinct() %>%
      dplyr::mutate("related_tag" = "metagroup")

    tags6 <- dplyr::tribble(
      ~tag,                    ~related_tag,
      "TCGA",                  "dataset",
      "extracellular_network", "network",
      "cellimage_network",     "network",
      "Immune_Subtype",        "TCGA",
      "TCGA_Subtype",          "TCGA",
      "TCGA_Study",            "TCGA"

    )

    tags_to_tags <- dplyr::bind_rows(tags1, tags2, tags3, tags4, tags5, tags6)

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
