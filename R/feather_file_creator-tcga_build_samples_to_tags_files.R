tcga_build_samples_to_tags_files <- function() {

  library(magrittr)
  library(rlang)

  tcga_tags <- "syn23545011" %>%
    synapse_feather_id_to_tbl(.) %>%
    dplyr::select("tag" = "old_name", "new_tag" = "name") %>%
    tidyr::drop_na()

  samples_to_tags <- "syn22128019" %>%
    synapse_feather_id_to_tbl %>%
    dplyr::select(
      "sample" = "ParticipantBarcode",
      "TCGA_Study" = "Study",
      "Immune_Subtype" = "Subtype_Immune_Model_Based",
      "TCGA_Subtype" = "Subtype_Curated_Malta_Noushmehr_et_al"
    ) %>%
    tidyr::pivot_longer(-"sample", values_to = "tag") %>%
    tidyr::drop_na() %>%
    tidyr::pivot_longer(-"sample", values_to = "tag") %>%
    dplyr::select("sample", "tag") %>%
    dplyr::left_join(tcga_tags, by = "tag") %>%
    dplyr::mutate(
      "new_tag" = dplyr::if_else(
        is.na(.data$new_tag),
        .data$tag,
        .data$new_tag
      )
    ) %>%
    dplyr::select(-"tag") %>%
    dplyr::rename("tag" = "new_tag")

  iatlas.data::synapse_store_feather_file(
    samples_to_tags,
    "tcga_samples_to_tags.feather",
    "syn22125729"
  )
}
