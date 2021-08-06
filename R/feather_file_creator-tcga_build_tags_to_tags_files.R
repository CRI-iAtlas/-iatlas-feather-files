tcga_build_tags_to_tags_files <- function() {

  group_tags <- synapse_feather_id_to_tbl("syn23545186") %>%
    dplyr::select("tag", "related_tag")

  clinical_tags <-
    dplyr::bind_rows(
      dplyr::tibble("tag" = get_gender_enum(), "related_tag" = "gender"),
      dplyr::tibble("tag" = get_race_enum(), "related_tag" = "race"),
      dplyr::tibble("tag" = get_ethnicity_enum(), "related_tag" = "ethnicity")
    )

  tags_to_tags <- dplyr::bind_rows(group_tags, clinical_tags)


  iatlas.data::synapse_store_feather_file(
    tags_to_tags,
    "tcga_tags_to_tags.feather",
    "syn22125980"
  )

}
