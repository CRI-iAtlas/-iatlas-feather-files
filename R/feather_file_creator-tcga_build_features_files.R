tcga_build_features_files <- function() {

  get_features <- function() {

    germline_features <- "syn24862433" %>%
      synapse_feather_id_to_tbl() %>%
      dplyr::group_by(feature) %>%
      dplyr::arrange(.data$germline_module) %>%
      dplyr::slice(1)

    methods <- "syn22130608" %>%
      synapse_feather_id_to_tbl() %>%
      dplyr::select("origin" = "Feature Origin", "method_tag" = "Methods Tag") %>%
      tidyr::drop_na()

    features <- "syn22128265" %>%
      synapse_feather_id_to_tbl() %>%
      dplyr::filter(
        VariableType == "Numeric",
        !is.na(FriendlyLabel)
      ) %>%
      dplyr::select(
        "name" = "FeatureMatrixLabelTSV",
        "display" = "FriendlyLabel",
        "class" = "Variable Class",
        "order" = "Variable Class Order",
        "unit" = "Unit",
        "origin" = "Origin"
      ) %>%
      dplyr::mutate(
        "name" = stringr::str_replace_all(name, "[\\.]", "_"),
        class = dplyr::if_else(is.na(class), "Miscellaneous", class),
        class = dplyr::if_else(display %in% c("OS", "PFI"), "Survival Status", class),
        class = dplyr::if_else(display %in% c("OS Time", "PFI Time"), "Survival Time", class)
      ) %>%
      dplyr::filter(.data$class != "Clinical") %>%
      dplyr::left_join(methods, by = "origin") %>%
      dplyr::select(
        "name", "display", "class", "method_tag", "order", "unit"
      ) %>%
      dplyr::add_row(
        "name" = "Tumor_fraction",
        "display" = "Tumor Fraction",
        "class" = "Overall Proportion",
        "order" = 4,
        "unit"  = "Fraction"
      ) %>%
      dplyr::add_row(
        "name" = "totTCR_reads",
        "display" = "Total TCR reads",
        "class" = "Miscellaneous",
        "method_tag" = "TCR"
      ) %>%
      dplyr::filter(
        !(
          name == "til_percentage" &
          display == "TIL Regional Fraction (Percent)" &
          class == "Overall Proportion"
        )
      ) %>%
      dplyr::arrange(name) %>%
      dplyr::left_join(germline_features, by = c("name" = "feature"))

    return(features)
  }

  iatlas.data::synapse_store_feather_file(
    get_features(),
    "tcga_features.feather",
    "syn22125617"
  )
}
