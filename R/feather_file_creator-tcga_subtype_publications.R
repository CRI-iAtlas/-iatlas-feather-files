build_tcga_subtype_publications <- function(){

  require(magrittr)
  require(rlang)

  tbl <- "syn23545806" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "name" = "publication_name",
      "link",
      "journal",
      "year",
      "do_id",
      "pubmed_id",
      "first_author_last_name",
      "title"
    )

  iatlas.data::synapse_store_feather_file(
    tbl,
    "tcga_subtype_publications.feather",
    "syn22168316"
  )

}

