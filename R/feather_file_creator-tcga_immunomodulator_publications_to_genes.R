build_tcga_immunomodulator_publication_to_genes <- function(){

  require(magrittr)
  require(rlang)

  get_pubmed_tbl <- function(id){
    id %>%
      easyPubMed::get_pubmed_ids(., ) %>%
      easyPubMed::fetch_pubmed_data(., encoding = "ASCII") %>%
      easyPubMed::article_to_df(.) %>%
      dplyr::slice(., 1)
  }

  tbl1 <- "syn22151531" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("link" = "Reference(s) [PMID]", "entrez" = "Entrez ID") %>%
    tidyr::drop_na() %>%
    tidyr::separate_rows("link", sep = " \\| ") %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      "pubmed_id" = stringr::str_match(.data$link, "([:digit:]+$)")[,2]
    ) %>%
    dplyr::select(-"link")

  pubmed_tbl <- tbl1 %>%
    dplyr::select("pubmed_id") %>%
    dplyr::distinct() %>%
    dplyr::mutate("data" = purrr::map(.data$pubmed_id, get_pubmed_tbl )) %>%
    tidyr::unnest(cols = data) %>%
    dplyr::mutate(
      "doi" = dplyr::if_else(
        .data$doi == "",
        NA_character_,
        .data$doi
      )
    ) %>%
    tidyr::unite("publication_name", "doi", "pubmed_id", remove = F) %>%
    dplyr::select("publication_name", "pubmed_id")

  tbl <-
    dplyr::left_join(tbl1, pubmed_tbl, by = "pubmed_id") %>%
    dplyr::mutate("gene_type" = "immunomodulator") %>%
    dplyr::select(-"pubmed_id")


  iatlas.data::synapse_store_feather_file(
    tbl,
    "tcga_immunomodulator_publications_to_genes.feather",
    "syn22234818"
  )
}

