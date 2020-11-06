get_tcga_cellimage_nodes <- function() {

  cellimage_cells <- c(
    "B_cells",
    "Dendritic_cells",
    "Eosinophils",
    "Macrophage",
    "Mast_cells",
    "NK_cells",
    "Neutrophils",
    "T_cells_CD4",
    "T_cells_CD8"
  )

  position_tbl <- iatlas.data::synapse_feather_id_to_tbl("syn21781366")
  nodes_tbl    <- get_tcga_extracellular_network_nodes() %>%
    dplyr::select(tag, tag_2, feature, entrez, label, score)
  label_tbl    <- iatlas.data::synapse_feather_id_to_tbl("syn21782167")

  cellimage_nodes <- label_tbl %>%
    dplyr::select(From, To) %>%
    tidyr::pivot_longer(
      .,
      c("From", "To"),
      values_to = "node",
      names_to = "type"
    ) %>%
    dplyr::select(node) %>%
    dplyr::distinct() %>%
    dplyr::full_join(position_tbl, by = c(node = "Variable")) %>%
    dplyr::left_join(iatlas.data::get_tcga_gene_ids(), by = c("node" = "hgnc")) %>%
    dplyr::mutate(node = dplyr::if_else(
      !is.na(entrez),
      as.character(entrez),
      dplyr::if_else(
        node %in% cellimage_cells,
        paste0(node, "_Aggregate2"),
        dplyr::if_else(
          node == "Tumor_cell",
          "Tumor_fraction",
          NA_character_
        )
      )
    )) %>%
    dplyr::select(-entrez)

  gene_nodes <- nodes_tbl %>%
    dplyr::mutate(entrez = as.character(entrez)) %>%
    dplyr::inner_join(cellimage_nodes, by = c("entrez" = "node")) %>%
    dplyr::mutate_at(dplyr::vars(entrez), as.numeric)

  feature_nodes <- nodes_tbl %>%
    dplyr::inner_join(cellimage_nodes, by = c("feature" = "node"))

  nodes_tbl2 <-
    dplyr::bind_rows(gene_nodes, feature_nodes) %>%
    dplyr::mutate(
      dataset = "TCGA",
      "network" = "cellimage_network",
      "name" = stringr::str_c("tcga_ecn_", 1:dplyr::n())
    )
}

get_tcga_cellimage_edges <- function() {
  cellimage_cells <- c(
    "B_cells",
    "Dendritic_cells",
    "Eosinophils",
    "Macrophage",
    "Mast_cells",
    "NK_cells",
    "Neutrophils",
    "T_cells_CD4",
    "T_cells_CD8"
  )
  extracellular_nodes_tbl <- get_tcga_extracellular_network_nodes() %>%
    dplyr::select(feature, entrez, name)
  extracellular_edges_tbl <- get_tcga_extracellular_network_edges() %>%
    dplyr::select(node1, node2, score)
  cellimage_nodes_tbl     <- get_tcga_cellimage_nodes() %>%
    dplyr::select(feature, entrez, name)

  cellimage_edges_tbl1 <- "syn21782167" %>%
    iatlas.data::synapse_feather_id_to_tbl() %>%
    dplyr::select(from = From, to = To, label = interaction) %>%
    dplyr::left_join(iatlas.data::get_tcga_gene_ids(), by = c("from" = "hgnc")) %>%
    dplyr::mutate(from = dplyr::if_else(
      !is.na(entrez),
      as.character(entrez),
      dplyr::if_else(
        from %in% cellimage_cells,
        paste0(from, "_Aggregate2"),
        dplyr::if_else(
          from == "Tumor_cell",
          "Tumor_fraction",
          NA_character_
        )
      )
    )) %>%
    dplyr::select(-entrez) %>%
    dplyr::left_join(iatlas.data::get_tcga_gene_ids(), by = c("to" = "hgnc")) %>%
    dplyr::mutate(to = dplyr::if_else(
      !is.na(entrez),
      as.character(entrez),
      dplyr::if_else(
        to %in% cellimage_cells,
        paste0(to, "_Aggregate2"),
        dplyr::if_else(
          to == "Tumor_cell",
          "Tumor_fraction",
          NA_character_
        )
      )
    )) %>%
    dplyr::select(-entrez)

  feature_edges1 <- cellimage_edges_tbl1 %>%
    dplyr::inner_join(extracellular_nodes_tbl, .,  by = c("feature" = "from")) %>%
    dplyr::select(-"entrez") %>%
    dplyr::rename(ecn_node1 = id) %>%
    dplyr::inner_join(
      dplyr::select(cellimage_nodes_tbl, -"entrez"),
      by = "feature"
    ) %>%
    dplyr::select(-"feature") %>%
    dplyr::rename(node1 = id)


  genes_edges1 <- cellimage_edges_tbl1 %>%
    dplyr::mutate("from" = as.integer(from)) %>%
    dplyr::filter(!is.na(from)) %>%
    dplyr::inner_join(extracellular_nodes_tbl, .,  by = c("entrez" = "from")) %>%
    dplyr::select(-"feature") %>%
    dplyr::rename(ecn_node1 = id) %>%
    dplyr::inner_join(
      dplyr::select(cellimage_nodes_tbl, -"feature"),
      by = "entrez"
    ) %>%
    dplyr::rename(node1 = id) %>%
    dplyr::select(-"entrez")

  cellimage_edges_tbl2 <-
    dplyr::bind_rows(feature_edges1, genes_edges1)

  feature_edges2 <- cellimage_edges_tbl2 %>%
    dplyr::inner_join(extracellular_nodes_tbl, .,  by = c("feature" = "to")) %>%
    dplyr::select(-"entrez") %>%
    dplyr::rename(ecn_node1 = id) %>%
    dplyr::inner_join(
      dplyr::select(cellimage_nodes_tbl, -"entrez"),
      by = "feature"
    ) %>%
    dplyr::select(-"feature") %>%
    dplyr::rename(node1 = id)

  genes_edges1 <- cellimage_edges_tbl1 %>%
    dplyr::mutate("from" = as.integer(from)) %>%
    dplyr::filter(!is.na(from)) %>%
    dplyr::inner_join(extracellular_nodes_tbl, .,  by = c("entrez" = "from")) %>%
    dplyr::rename(ecn_node1 = id) %>%
    dplyr::inner_join(cellimage_nodes_tbl) %>%
    dplyr::rename(node1 = id) %>%
    dplyr::select(-c("feature", "entrez"))

  cellimage_edges_tbl3 <-
    dplyr::bind_rows(feature_edges2, genes_edges2) %>%
    dplyr::distinct() %>%
    dplyr::left_join(extracellular_edges_tbl, by = c("node1", "node2")) %>%
    dplyr::select(-c("node1", "node2"))

}
