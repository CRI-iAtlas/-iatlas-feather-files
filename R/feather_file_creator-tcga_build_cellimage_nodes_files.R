tcga_build_cellimage_nodes_files <- function() {

  tcga_tags <- "syn23545011" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("tag" = "old_name", "new_tag" = "name") %>%
    tidyr::drop_na()

  nodes <-
    c("syn23538719", "syn23538721", "syn23538726") %>%
    purrr::map(iatlas.data::synapse_feather_id_to_tbl) %>%
    dplyr::bind_rows() %>%
    dplyr::select(
      "node"  = "Node",
      "tag"   = "Group",
      "score" = "UpBinRatio",
      "x",
      "y"
    ) %>%
    dplyr::mutate(
      dataset = "TCGA",
      "network" = "cellimage_network",
      "name" = stringr::str_c("tcga_cin_", 1:dplyr::n())
    ) %>%
    dplyr::mutate(
      "entrez" = as.integer(.data$node),
      "feature" = dplyr::if_else(
        is.na(.data$entrez),
        .data$node,
        NA_character_
      )
    ) %>%
    dplyr::select(-"node") %>%
    dplyr::left_join(tcga_tags, by = "tag") %>%
    dplyr::select(-"tag") %>%
    dplyr::rename("tag" = "new_tag")

  iatlas.data::synapse_store_feather_file(
    nodes,
    "tcga_cellimage_network_nodes.feather",
    "syn22126180"
  )
}
