tcga_build_cellimage_nodes_to_tags_file <- function() {

  immune_subtype_nodes_to_tags <- "syn23538719" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes_to_tags,
    "tcga_cellimage_immune_subtype_nodes_to_tags.feather",
    "syn26023432"
  )

  tcga_study_nodes_to_tags <- "syn23538721" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    tcga_study_nodes_to_tags,
    "tcga_cellimage_tcga_study_nodes_to_tags.feather",
    "syn26023432"
  )

  tcga_subtype_nodes_to_tags <- "syn23538726" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select("node" = "name", "tag")

  iatlas.data::synapse_store_feather_file(
    tcga_subtype_nodes_to_tags,
    "tcga_cellimage_tcga_subtype_nodes_to_tags.feather",
    "syn26023432"
  )

}
