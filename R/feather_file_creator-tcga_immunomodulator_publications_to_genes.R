build_tcga_immunomodulator_publication_to_genes <- function(){

  tbl <- "syn22151531" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select(
      "entrez" = "Entrez ID",
      "link" = "Reference(s) [PMID]"
    ) %>%
    tidyr::drop_na() %>%
    tidyr::separate_rows("link", sep = " \\| ") %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      "link" = stringr::str_remove_all(.data$link, "\\/$"),
      "pubmed_id" = stringr::str_match(.data$link, "([:digit:]+$)")[,2]
    ) %>%
    dplyr::select(-"link")

  iatlas.data::synapse_store_feather_file(
    tbl,
    "tcga_immunomodulator_publications_to_genes.feather",
    "syn22168383"
  )
}

