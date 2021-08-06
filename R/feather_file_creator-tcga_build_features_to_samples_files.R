tcag_build_features_to_samples_files1 <- function() {

  redone_classes <- c(
    "Immune Cell Proportion - Common Lymphoid and Myeloid Cell Derivative Class",
    "Immune Cell Proportion - Differentiated Lymphoid and Myeloid Cell Derivative Class",
    "Immune Cell Proportion - Multipotent Progenitor Cell Derivative Class",
    "Immune Cell Proportion - Original"
  )

  features <- "syn26033240" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::filter(!.data$class %in% redone_classes) %>%
    dplyr::pull("name")


  features_to_samples <- "syn22128019" %>%
    synapse_feather_id_to_tbl(.) %>%
    dplyr::rename_all(~stringr::str_replace_all(.x, "[\\.]", "_")) %>%
    dplyr::mutate("Tumor_fraction" = 1 - .data$Stromal_Fraction) %>%
    dplyr::rename("sample" = "ParticipantBarcode") %>%
    dplyr::select(dplyr::all_of(c("sample", features))) %>%
    tidyr::pivot_longer(-"sample", names_to = "feature") %>%
    tidyr::drop_na() %>%
    dplyr::arrange(feature, sample) %>%
    dplyr::select("feature", "sample", "value")

  synapse_store_feather_file(
    features_to_samples,
    "tcga_features_to_samples.feather",
    "syn22125635"
  )
}
