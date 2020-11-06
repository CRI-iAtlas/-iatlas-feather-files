tcga_build_tags_files <- function() {

  tags <- "syn23545011" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "name","short_display", "long_display", "color", "characteristics"
    )

  iatlas.data::synapse_store_feather_file(
    tags,
    "tcga_tags.feather",
    "syn22125978"
  )

}
