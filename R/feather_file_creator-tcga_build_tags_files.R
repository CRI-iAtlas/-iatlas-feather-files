tcga_build_tags_files <- function() {

  group_tags <- "syn23545011" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "name","short_display", "long_display", "color", "characteristics"
    )

  clinical_tags <-
    dplyr::tibble(
      "name" = c(
        get_gender_enum(),
        get_race_enum(),
        get_ethnicity_enum(),
        get_clinical_enum()
      )
    ) %>%
    dplyr::mutate(
      "short_display" = stringr::str_to_sentence(.data$name),
      "long_display" = .data$short_display
    )

  tags <- dplyr::bind_rows(group_tags, clinical_tags)

  iatlas.data::synapse_store_feather_file(
    tags,
    "tcga_tags.feather",
    "syn22125978"
  )

}
