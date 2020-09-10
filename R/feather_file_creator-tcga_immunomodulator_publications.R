build_tcga_immunomodulator_publications <- function(){
  require(magrittr)
  require(rlang)

  tbl <- "syn22151531" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("link" = "Reference(s) [PMID]") %>%
    tidyr::drop_na() %>%
    tidyr::separate_rows("link", sep = " \\| ") %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      "link" = stringr::str_remove_all(.data$link, "\\/$"),
      "pubmed_id" = stringr::str_match(.data$link, "([:digit:]+$)")[,2]
    ) %>%
    dplyr::pull("pubmed_id") %>%
    purrr::map(easyPubMed::get_pubmed_ids) %>%
    purrr::map(easyPubMed::fetch_pubmed_data, encoding = "ASCII") %>%
    purrr::map(easyPubMed::article_to_df) %>%
    purrr::map(dplyr::slice, 1) %>%
    dplyr::bind_rows() %>%
    dplyr::as_tibble() %>%
    dplyr::select(
      "do_id" = "doi",
      "pubmed_id" = "pmid",
      "journal" = "jabbrv",
      "first_author_last_name" = "lastname",
      "year",
      "title"
    ) %>%
    dplyr::mutate("do_id" = dplyr::if_else(
      .data$do_id == "",
      NA_character_,
      .data$do_id
    )) %>%
    tidyr::unite("name", "do_id", "pubmed_id", remove = F)

  iatlas.data::synapse_store_feather_file(
    tbl,
    "tcga_immunomodulator_publications.feather",
    "syn22168316"
  )

}

