tcga_build_viral_features_files <- function() {

  features_to_keep <- c(
    "Hepatitis_B_virus_(strain_ayw)_genome.NC_003977.2",
    "Human_adenovirus_2.AC_000007.1",
    "Human_adenovirus_5.AC_000008.1",
    "Human_adenovirus_C.NC_001405.1",
    "Human_adenovirus_type_1.AC_000017.1",
    "Human_herpesvirus_1_strain_17.NC_001806.2",
    "Human_herpesvirus_4_complete_wild_type_genome.NC_007605.1",
    "Human_herpesvirus_4.NC_009334.1",
    "Human_herpesvirus_5_strain_Merlin.NC_006273.2",
    "Human_herpesvirus_6B.NC_000898.1",
    "Human_immunodeficiency_virus_1.NC_001802.1",
    "Human_papillomavirus_-_18.NC_001357.1",
    "Human_papillomavirus_type_135.NC_017993.1",
    "Human_papillomavirus_type_16.NC_001526.2",
    "Human_papillomavirus_type_26.NC_001583.1",
    "Human_polyomavirus_7.NC_014407.1",
    "Merkel_cell_polyomavirus_isolate_R17b.NC_010277.2"
  )

  aliquots_to_keep <- "syn21435422" %>%
    synapse_delimited_id_to_tbl() %>%
    dplyr::rename("patient" = 1, "aliqout" = 2) %>%
    tidyr::drop_na() %>%
    dplyr::pull("aliqout")

  feature_values <- "syn24827088" %>%
    synapse_delimited_id_to_tbl()

  samples <- "syn24827083" %>%
    synapse_delimited_id_to_tbl() %>%
    dplyr::filter(.data$tcga_barcode %in%  aliquots_to_keep) %>%
    dplyr::mutate("tcga_barcode" = stringr::str_sub(.data$tcga_barcode, end = 12))

  features <- feature_values %>%
    colnames() %>%
    dplyr::as_tibble() %>%
    dplyr::slice(-1) %>%
    dplyr::rename("old_name" = "value") %>%
    tidyr::separate("old_name", c("a", "b", "c", "d", "e", "f"), "\\|", remove = F) %>%
    tidyr::drop_na() %>%
    dplyr::select("old_name", "e", "d") %>%
    dplyr::mutate("filter_name" = stringr::str_c(.data$e, .data$d, sep = ".")) %>%
    dplyr::filter(.data$filter_name %in% features_to_keep) %>%
    dplyr::mutate(
      "name" = stringr::str_replace_all(.data$e, "[:punct:]", "_"),
      "name" = stringr::str_replace_all(.data$name, "[:space:]", "_"),
      "name" = stringr::str_replace_all(.data$name, "_+", "_"),
      "display" = stringr::str_replace_all(.data$e, "_", " "),
      "display" = stringr::str_to_title(.data$display),
      "class" = "VirDetect Viral Count",
      "unit"  = "Count"
    ) %>%
    dplyr::select(-c("e", "d", "filter_name"))

  feature_values2 <- feature_values %>%
    tidyr::pivot_longer(-"sample", names_to = "old_name") %>%
    dplyr::inner_join(samples, by = "sample") %>%
    dplyr::select("sample" = "tcga_barcode", "old_name", "value") %>%
    dplyr::inner_join(
      dplyr::select(features, "old_name", "feature" = "name"),
      by = "old_name"
    ) %>%
    dplyr::select("sample", "feature", "value")

  features2 <- dplyr::select(features, -c("old_name"))


  iatlas.data::synapse_store_feather_file(
    features2,
    "tcga_virdetect_viral_features.feather",
    "syn22125617"
  )

  iatlas.data::synapse_store_feather_file(
    feature_values2,
    "tcga_virdetect_viral_features_to_samples.feather",
    "syn22125635"
  )
}
