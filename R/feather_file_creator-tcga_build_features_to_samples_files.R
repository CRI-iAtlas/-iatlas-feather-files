tcag_build_features_to_samples_files1 <- function() {

  get_features_to_samples <- function() {

    cat(crayon::magenta(paste0("Get features_to_samples")), fill = TRUE)

    create_global_synapse_connection()

    methods <- "syn22130608" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
      dplyr::select("origin" = "Feature Origin", "method_tag" = "Methods Tag") %>%
      tidyr::drop_na()

    features <- "syn22128265" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
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
      dplyr::pull(name)

    features_to_samples <- "syn22128019" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      arrow::read_feather(.) %>%
      dplyr::rename_all(~stringr::str_replace_all(.x, "[\\.]", "_")) %>%
      dplyr::mutate("Tumor_fraction" = 1 - .data$Stromal_Fraction) %>%
      dplyr::rename("sample" = "ParticipantBarcode") %>%
      dplyr::select(dplyr::all_of(c("sample", features))) %>%
      tidyr::pivot_longer(-"sample", names_to = "feature") %>%
      tidyr::drop_na() %>%
      dplyr::arrange(feature, sample) %>%
      dplyr::select("feature", "sample", "value")

    return(features_to_samples)
  }

  .GlobalEnv$tcga_features_to_samples <- iatlas.data::synapse_store_feather_file(
    get_features_to_samples(),
    "tcga_features_to_samples.feather",
    "syn22125635"
  )
}
