build_epic_features <- function() {

  features <- c(
    "EPIC_B_Cells",
    "EPIC_CAFs",
    "EPIC_CD4_T_Cells",
    "EPIC_CD8_T_Cells",
    "EPIC_Endothelial",
    "EPIC_Macrophages",
    "EPIC_NK_Cells",
    "EPIC_Other_Cells"
  )

  feature_tbl <- features %>%
    dplyr::tibble("name" = .) %>%
    dplyr::mutate("display" = ) %>%
    dplyr::mutate(
      display = stringr::str_replace_all(name, "_", " "),
      class = "EPIC",
      unit = "Fraction"
    )



  iatlas.data::synapse_store_feather_file(
    feature_tbl,
    "epic_features.feather",
    "syn22125617"
  )

}
