build_mcpcounter_features <- function() {

  features <- c(
    "MCPcounter_T_Cells",
    "MCPcounter_Cd8_T_Cells",
    "MCPcounter_Cytotoxic_Lymphocytes",
    "MCPcounter_Nk_Cells",
    "MCPcounter_B_Lineage",
    "MCPcounter_Monocytic_Lineage",
    "MCPcounter_Myeloid_Dendritic_Cells",
    "MCPcounter_Neutrophils",
    "MCPcounter_Endothelial_Cells",
    "MCPcounter_Fibroblasts"
  )

  feature_tbl <- features %>%
    dplyr::tibble("name" = .) %>%
    dplyr::mutate("display" = ) %>%
    dplyr::mutate(
      display = stringr::str_replace_all(name, "_", " "),
      class = "MCPcounter",
      unit = "Score"
    )

  iatlas.data::synapse_store_feather_file(
    feature_tbl,
    "mcpcounter_features.feather",
    "syn22125617"
  )

}
