tcga_build_samples_to_tags_files <- function() {

  require(magrittr)

  get_samples_to_tags <- function() {

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
      dplyr::filter(tag != "dataset") %>%
      dplyr::arrange(sample, tag)


    return(samples_to_tags)
  }

  iatlas.data::synapse_store_feather_file(
    get_samples_to_tags(),
    "tcga_samples_to_tags.feather",
    "syn22125729"
  )
}
