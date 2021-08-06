tcga_build_cellimage_nodes_files <- function() {

  iatlas.data::synapse_store_feather_file(
    dplyr::tibble(name = character()),
    "deprecated_tcga_cellimage_network_nodes.feather",
    "syn22126180"
  )

  immune_subtype_nodes <- "syn23538719" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "dataset", "x", "y")

  iatlas.data::synapse_store_feather_file(
    immune_subtype_nodes,
    "tcga_cellimage_immune_subtype_nodes.feather",
    "syn22126180"
  )

  tcga_study_nodes <- "syn23538721" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "dataset", "x", "y")

  iatlas.data::synapse_store_feather_file(
    tcga_study_nodes,
    "tcga_cellimage_tcga_study_nodes.feather",
    "syn22126180"
  )

  tcga_subtype_nodes <- "syn23538726" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::mutate("network" = "Cellimage Network") %>%
    dplyr::select("name", "network", "feature", "entrez", "score", "dataset", "x", "y")

  iatlas.data::synapse_store_feather_file(
    tcga_subtype_nodes,
    "tcga_cellimage_tcga_subtype_nodes.feather",
    "syn22126180"
  )

}
