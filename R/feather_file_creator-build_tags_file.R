build_tags <- function(){
  tags <-
    dplyr::tibble(
      "name" = character(),
      "short_display" = character(),
      "long_display" = character()
    ) %>%
    dplyr::add_row(
      "name" = c("extracellular_network", "cellimage_network"),
      "short_display" = c("Extracellular Network", "Cellimage Network"),
      "long_display" = c("Extracellular Network", "Cellimage Network")
    ) %>%
    dplyr::add_row(
      "name" = c("parent_group", "metagroup", "group", "network"),
      "short_display" = c("Parent Group", "Metagroup", "Group", "Network"),
      "long_display" = c("Parent Group", "Metagroup", "Group", "Network")
    )

  iatlas.data::synapse_store_feather_file(
    tags,
    "tags.feather",
    "syn22125978"
  )
}
