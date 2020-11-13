pcawg_build_tags_files <- function() {

  require(magrittr)

  get_tags <- function() {

    tags <- iatlas.data::get_pcawg_tag_values_cached() %>%
      dplyr::select(name = tag) %>%
      dplyr::distinct() %>%
      dplyr::filter(!stringr::str_detect(name, "C[:digit:]")) %>%
      dplyr::filter(name != "PCAWG") %>%
      dplyr::mutate(
        "short_display" = name,
        "long_display" = name
      ) %>%
      dplyr::add_row(
        name = "PCAWG_Study",
        short_display = "PCAWG Study",
        long_display = "PCAWG Study"
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
