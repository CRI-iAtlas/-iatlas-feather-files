build_network_tags <- function(){
  tags <-
    dplyr::tibble(
      "name" = character(),
      "short_display" = character(),
      "long_display" = character(),
      "type" = character()
    ) %>%
    dplyr::add_row(
      "name" = c("extracellular_network", "cellimage_network"),
      "short_display" = c("Extracellular Network", "Cellimage Network"),
      "long_display" = c("Extracellular Network", "Cellimage Network"),
      "type" = "network"
    )

  iatlas.data::synapse_store_feather_file(
    tags,
    "tags.feather",
    "syn22125978"
  )
}
