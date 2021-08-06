pcawg_build_tags_to_tags_files <- function() {

  require(magrittr)

  get_tags_to_tags <- function() {

    cat(crayon::magenta(paste0("Get pcawg tags_to_tags.")), fill = TRUE)

    get_pcawg_tags_from_synapse() %>%
      dplyr::select(tag = dcc_project_code) %>%
      dplyr::distinct() %>%
      dplyr::mutate(related_tag = "PCAWG_Study")

  }

  iatlas.data::synapse_store_feather_file(
    get_tags_to_tags(),
    "pcawg_tags_to_tags.feather",
    "syn22125980"
  )

}
