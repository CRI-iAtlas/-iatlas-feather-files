pcawg_build_samples_to_tags_files <- function() {
  require(magrittr)

  samples_to_immune_subtype_tags <- "syn26066983" %>%
    synapse_delimited_id_to_tbl() %>%
    dplyr::select("sample", "tag" = "subtype")

  iatlas.data::synapse_store_feather_file(
    samples_to_immune_subtype_tags,
    "ici_immmune_subtypes_samples_to_tags.feather",
    "syn22125729"
  )

}
