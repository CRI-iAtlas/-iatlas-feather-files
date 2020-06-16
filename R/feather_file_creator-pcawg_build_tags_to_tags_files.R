pcawg_build_tags_to_tags_files <- function() {

  require(magrittr)

  get_tags_to_tags <- function() {

    cat(crayon::magenta(paste0("Get pcawg tags_to_tags.")), fill = TRUE)

    tags1 <- get_pcawg_tags_from_synapse() %>%
      dplyr::select(tag = dcc_project_code) %>%
      dplyr::distinct() %>%
      dplyr::mutate(related_tag = "PCAWG_Study")

    tags2 <- tags1 %>%
      dplyr::select("tag") %>%
      dplyr::mutate(related_tag = "group")

    tags3 <- dplyr::tribble(
      ~tag,            ~related_tag,
      "PCAWG_Study",    "parent_group"
    )

    tags_to_tags <- dplyr::bind_rows(tags1, tags2, tags3)

    return(tags_to_tags)
  }

  iatlas.data::synapse_store_feather_file(
    get_tags_to_tags(),
    "pcawg_tags_to_tags.feather",
    "syn22125980"
  )

}
