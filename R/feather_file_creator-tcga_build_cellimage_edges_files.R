tcga_build_cellimage_edges_files <- function() {

  edges <-
    c("syn23538718", "syn23538720", "syn23538725") %>%
    purrr::map(iatlas.data::synapse_feather_id_to_tbl) %>%
    dplyr::bind_rows() %>%
    dplyr::select(
      "from"  = "From",
      "to"    = "To",
      "score" = "ratioScore",
      "tag" = "Group",
      "label"
    ) %>%
    dplyr::mutate(
      "node1" = stringr::str_c("tcga_cin_", .data$tag, "_", .data$from),
      "node2" = stringr::str_c("tcga_cin_", .data$tag, "_", .data$to),
      "dataset" = "TCGA",
      "network" = "cellimage_network",
      "name" = stringr::str_c(
        "tcga_cin_", .data$tag, "_", .data$from, "_", .data$to
      )
    ) %>%
    dplyr::select(
      "name", "score", "node1", "node2", "dataset", "network", "label"
    )

  iatlas.data::synapse_store_feather_file(
    edges,
    "tcga_cellimage_network_edges.feather",
    "syn22126181"
  )
}
