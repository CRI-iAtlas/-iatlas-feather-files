pcawg_build_samples_to_tags_files <- function() {
  require(magrittr)

  samples_to_pcawg_study_tags <- "syn21785582" %>%
    synapse_delimited_id_to_tbl() %>%
    dplyr::select("sample" = "icgc_donor_id", "tag" = "dcc_project_code")

  samples_to_pcawg_study <- samples_to_pcawg_study_tags  %>%
    dplyr::mutate(tag = "PCAWG_Study")

  samples_to_immune_subtype_tags <- "syn20717211" %>%
    synapse_delimited_id_to_tbl() %>%
    dplyr::select("sample", "tag" = "subtype")

  samples_to_immune_subtype <- samples_to_immune_subtype_tags %>%
    dplyr::mutate(tag = "Immune_Subtype")

  samples_to_tags <-
    dplyr::bind_rows(
      samples_to_pcawg_study_tags,
      samples_to_immune_subtype_tags,
      samples_to_pcawg_study,
      samples_to_immune_subtype
    ) %>%
    dplyr::arrange(sample, tag)

  iatlas.data::synapse_store_feather_file(
    samples_to_tags,
    "pcawg_samples_to_tags.feather",
    "syn22125729"
  )

}
