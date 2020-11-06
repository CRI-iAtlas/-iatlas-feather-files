tcga_build_tags_to_tags_files <- function() {

  tags_to_tags <- synapse_feather_id_to_tbl("syn23545186") %>%
    dplyr::select("tag", "related_tag")

  iatlas.data::synapse_store_feather_file(
    tags_to_tags,
    "tcga_tags_to_tags.feather",
    "syn22125980"
  )

}
