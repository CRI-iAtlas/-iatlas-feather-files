build_tcga_subtypes_to_publications <- function(){

  require(magrittr)
  require(rlang)

  tbl <- "syn23545806" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("publication_name", "tag_name")

  iatlas.data::synapse_store_feather_file(
    tbl,
    "tcga_subtypes_to_publications.feather",
    "syn22242574"
  )

}

