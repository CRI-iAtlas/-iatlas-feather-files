get_tcga_extracellular_network_nodes <- function() {
  require(magrittr)
  labels <- "syn21783989" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("node" = "Obj", "label" = "Type")

  cell_features <- c(
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

  node_tbl <-
    c("syn21781358", "syn21781359", "syn21781360", "syn21781362") %>%
    purrr::map(iatlas.data::synapse_feather_id_to_tbl) %>%
    dplyr::bind_rows() %>%
    dplyr::select(
      node  = Node,
      tag   = Group,
      score = UpBinRatio,
      tag_2  = Immune
    ) %>%
    dplyr::left_join(labels, by = "node") %>%
    dplyr::mutate(
      node = dplyr::case_when(
        node %in% cell_features ~ stringr::str_c(node, "_Aggregate2"),
        node == "Tumor_cell" ~ "Tumor_fraction",
        T ~ node),
      label = dplyr::case_when(
        is.na(label) ~ "Gene",
        T ~ label
      )
    ) %>%
    dplyr::filter(!is.na(tag))

  feature_node_tbl <- node_tbl %>%
    dplyr::filter(label == "Cell") %>%
    dplyr::rename(feature = node)

  gene_node_tbl <- node_tbl %>%
    dplyr::filter(label != "Cell") %>%
    dplyr::rename(hgnc = node) %>%
    dplyr::left_join(iatlas.data::get_tcga_gene_ids(), by = "hgnc") %>%
    dplyr::select(-hgnc)

  node_tbl <-
    dplyr::bind_rows(feature_node_tbl, gene_node_tbl) %>%
    dplyr::mutate(
      dataset = "TCGA",
      "network" = "extracellular_network",
      "name" = stringr::str_c("tcga_ecn_", 1:dplyr::n())
    )
}

get_tcga_extracellular_network_edges <- function() {
  require(magrittr)
  nodes_tbl <- get_tcga_extracellular_network_nodes_cached() %>%
    dplyr::select(name, feature, entrez, tag, tag_2) %>%
    dplyr::mutate("entrez" = as.character(entrez))

  edges_tbl <-
    c("syn21781350", "syn21781351", "syn21781354", "syn21781357") %>%
    purrr::map(iatlas.data::synapse_feather_id_to_tbl) %>%
    dplyr::bind_rows() %>%
    dplyr::select(
      from  = From,
      to    = To,
      score = ratioScore,
      tag   = Group,
      tag_2 = Immune
    ) %>%
    dplyr::filter(!is.na(tag)) %>%
    dplyr::left_join(iatlas.data::get_tcga_gene_ids(), by = c("from" = "hgnc")) %>%
    dplyr::mutate(from = dplyr::if_else(
      is.na(entrez),
      paste0(from, "_Aggregate2"),
      as.character(entrez)
    )) %>%
    dplyr::select(-entrez) %>%
    dplyr::left_join(iatlas.data::get_tcga_gene_ids(), by = c("to" = "hgnc")) %>%
    dplyr::mutate(to = dplyr::if_else(
      is.na(entrez),
      paste0(to, "_Aggregate2"),
      as.character(entrez)
    )) %>%
    dplyr::select(-entrez) %>%
    dplyr::filter(!is.na(tag))

  feature_edges_tbl1 <- edges_tbl %>%
    dplyr::inner_join(nodes_tbl, by = c("from" = "feature", "tag", "tag_2")) %>%
    dplyr::select(-c("from", "entrez")) %>%
    dplyr::rename("node1" = name)

  gene_edges_tbl1 <- edges_tbl %>%
    dplyr::inner_join(nodes_tbl, by = c("from" = "entrez", "tag", "tag_2")) %>%
    dplyr::select(-c("from", "feature")) %>%
    dplyr::rename("node1" = name)

  edges_tbl2 <- dplyr::bind_rows(feature_edges_tbl1, gene_edges_tbl1)

  feature_edges_tbl2 <- edges_tbl2 %>%
    dplyr::inner_join(nodes_tbl, by = c("to" = "feature", "tag", "tag_2")) %>%
    dplyr::select(-c("to", "entrez")) %>%
    dplyr::rename("node2" = name)

  gene_edges_tbl2 <- edges_tbl2 %>%
    dplyr::inner_join(nodes_tbl, by = c("to" = "entrez", "tag", "tag_2")) %>%
    dplyr::select(-c("to", "feature")) %>%
    dplyr::rename("node2" = name)

  edges_tbl3 <- dplyr::bind_rows(feature_edges_tbl2, gene_edges_tbl2) %>%
    dplyr::select(-c("tag", "tag_2")) %>%
    dplyr::mutate("name" = stringr::str_c("tcga_ecn_", 1:dplyr::n()))
}
