tcga_build_cellimage_edges_files <- function() {


  oe <- iatlas.data::synapse_feather_id_to_tbl("syn22213099")

  edges <-
    c("syn23538718", "syn23538720", "syn23538725") %>%
    purrr::map(iatlas.data::synapse_feather_id_to_tbl) %>%
    dplyr::bind_rows() %>%
    dplyr::select(
      "from"  = "From",
      "to"    = "To",
      "score" = "ratioScore",
    )


  # iatlas.data::synapse_store_feather_file(
  #   get_tcga_extracellular_network_edges_cached(),
  #   "tcga_extracellular_network_edges.feather",
  #   "syn22126181"
  # )
}
