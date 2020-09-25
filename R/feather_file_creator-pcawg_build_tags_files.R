pcawg_build_tags_files <- function() {

  require(magrittr)

  get_tags <- function() {

    cat(crayon::magenta(paste0("Get PCAWG tags.")), fill = TRUE)

    tags <- iatlas.data::get_pcawg_tag_values_cached() %>%
      dplyr::select(name = tag) %>%
      dplyr::distinct() %>%
      dplyr::filter(!stringr::str_detect(name, "C[:digit:]")) %>%
      dplyr::filter(name != "PCAWG") %>%
      dplyr::add_row(name = "PCAWG_Study") %>%
      dplyr::mutate(
        "display" = name,
        "short_display" = name,
        "long_display" = name
      ) %>%
      dplyr::arrange(name)

    return(tags)
  }

  iatlas.data::synapse_store_feather_file(
    get_tags(),
    "pcawg_tags.feather",
    "syn22125978"
  )

}
