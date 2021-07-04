pcawg_build_tags_to_tags_files <- function() {

  require(magrittr)

  get_tags_to_tags <- function() {

    tags_to_tags <- dplyr::tribble(
      ~tag,                     ~related_tag,
      "extracellular_network",  "network",
      "cellimage_network",      "network",
    )

    return(tags_to_tags)
  }

  iatlas.data::synapse_store_feather_file(
    get_tags_to_tags(),
    "tags_to_tags.feather",
    "syn22125980"
  )

}
