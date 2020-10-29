build_extracellular_network_files <- function(){

  hgnc_labels <- "syn21783989" %>%
    synapse_feather_id_to_tbl %>%
    dplyr::select("value" = "Obj", "label" = "Type")

  hgnc_scaffold <- "syn21781350" %>%
    synapse_feather_id_to_tbl %>%
    dplyr::select("from" = "From", "to" = "To") %>%
    dplyr::distinct() %>%
    dplyr::mutate("number" = 1:dplyr::n()) %>%
    tidyr::pivot_longer(-"number")

  tcga_genes <- "syn22133677" %>%
    synapse_feather_id_to_tbl %>%
    tidyr::drop_na() %>%
    dplyr::mutate("entrez" = as.character(entrez))

  genes <- "syn22240716" %>%
    synapse_feather_id_to_tbl %>%
    tidyr::drop_na() %>%
    dplyr::mutate("entrez" = as.character(entrez))

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

  hgnc_translation1 <- hgnc_scaffold %>%
    dplyr::select("value") %>%
    dplyr::distinct() %>%
    dplyr::inner_join(genes, by = c("value" = "hgnc")) %>%
    dplyr::rename("new_value" = "entrez")

  hgnc_translation2 <- hgnc_scaffold %>%
    dplyr::filter(!value %in% c(hgnc_translation1$value, cell_features)) %>%
    dplyr::select("value") %>%
    dplyr::distinct() %>%
    dplyr::inner_join(tcga_genes, by = c("value" = "hgnc")) %>%
    dplyr::rename("new_value" = "entrez")

  cell_translation <-
    hgnc_scaffold %>%
    dplyr::filter(value %in% c(cell_features)) %>%
    dplyr::select("value") %>%
    dplyr::distinct() %>%
    dplyr::mutate("new_value" = stringr::str_c(value, "_Aggregate2"))

  translation <-
    dplyr::bind_rows(
      hgnc_translation1, hgnc_translation2, cell_translation
    )

  entrez_scaffold <- hgnc_scaffold %>%
    dplyr::inner_join(translation) %>%
    dplyr::select(-value) %>%
    dplyr::rename(value = new_value) %>%
    tidyr::pivot_wider() %>%
    tidyr::drop_na() %>%
    dplyr::select(-number)

  entrez_labels <- hgnc_labels %>%
    dplyr::inner_join(translation, by = "value") %>%
    dplyr::select("node" = "new_value", "label")

  synapse_store_feather_file(
    entrez_scaffold,
    "fantom_scaffold.feather",
    "syn23518511"
  )

  synapse_store_feather_file(
    entrez_labels,
    "fantom_node_labels.feather",
    "syn23518511"
  )

}

