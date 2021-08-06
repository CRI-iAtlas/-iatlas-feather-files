build_tags_to_tags_files <- function() {

  iatlas.data::synapse_store_feather_file(
    dplyr::tibble(),
    "tags_to_tags.feather",
    "syn22125980"
  )

}
