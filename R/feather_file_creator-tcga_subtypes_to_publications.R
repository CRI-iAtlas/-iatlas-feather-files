build_tcga_subtype_publications <- function(){
  require(magrittr)
  require(rlang)

  doi_pattern <- "^https://doi.org/([:print:]+$)"
  nature_pattern <- "(https://doi.org/[:print:]+?/nature[:digit:]+)"
  cell_pattern <- "(https://doi.org/[:digit:]+.[:digit:]+/j.cell.[:digit:]+.[:digit:]+.[:digit:]+)"
  cancer_cell_pattern <- "(https://doi.org/[:digit:]+.[:digit:]+/j.cc[:print:]+?.[:digit:]+.[:digit:]+.[:digit:]+)"
  nejm_pattern <- "(https://doi.org/[:digit:]+.[:digit:]+/NEJMoa[:digit:]+)"

  get_doid_from_doi_link <- function(link){
    link %>%
      stringr::str_match(., doi_pattern) %>%
      purrr::pluck(2)
  }

  get_journal_do_pattern <- function(journal){
    if (journal == "Nature") return(nature_pattern)
    else if (journal == "Cell") return(cell_pattern)
    else if (journal == "Cancer Cell") return(cancer_cell_pattern)
    else if (journal == "Nejm") return(nejm_pattern)
  }

  get_doid_with_pattern <- function(link, pattern){
    link %>%
      curl::curl_fetch_memory(.) %>%
      purrr::pluck("content") %>%
      rawToChar() %>%
      stringr::str_match_all(., pattern) %>%
      unlist() %>%
      unique() %>%
      get_doid_from_doi_link(.)
  }

  get_doid <- function(link, journal){
    if (stringr::str_detect(link, doi_pattern)) {
      return(stringr::str_match(link, doi_pattern)[,2])
    } else if (journal %in% c("Nature", "Cell", "Cancer Cell", "Nejm")) {
      pattern <- get_journal_do_pattern(journal)
      return(get_doid_with_pattern(link, pattern))
    } else {
      return(NA_character_)
    }
  }

  tbl <- "syn22140514" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::filter(
      .data$sample_group == "Subtype_Curated_Malta_Noushmehr_et_al"
    ) %>%
    dplyr::select("temp" = "Characteristics") %>%
    dplyr::distinct() %>%
    tidyr::separate(
      "temp", " ; ",
      into = c("temp", "link"),
      extra = "merge"
    ) %>%
    tidyr::separate(
      "temp",
      " ",
      into = c("journal1", "journal2", "year"),
      fill = "left"
    ) %>%
    tidyr::unite("journal", "journal1", "journal2", sep = " ", na.rm = T) %>%
    dplyr::mutate("journal" = stringr::str_to_title(.data$journal)) %>%
    dplyr::arrange(.data$journal) %>%
    dplyr::mutate("link" = dplyr::if_else(
      .data$link == "http://linkinghub.elsevier.com/retrieve/pii/S0092-8674(17)30639-6",
      "https://www.cell.com/cell/fulltext/S0092-8674(17)30639-6",
      .data$link
    )) %>%
    dplyr::mutate("do_id" = purrr::map2_chr(.data$link, .data$journal, get_doid)) %>%
    dplyr::mutate("journal" = dplyr::if_else(
      .data$journal == "Nejm",
      "N. Engl. J. Med.",
      .data$journal
    ))

  pubmed_tbl <- tbl %>%
    dplyr::pull("do_id") %>%
    purrr::map(easyPubMed::get_pubmed_ids) %>%
    purrr::map(easyPubMed::fetch_pubmed_data, encoding = "ASCII") %>%
    purrr::map(easyPubMed::article_to_df) %>%
    purrr::map(dplyr::as_tibble) %>%
    purrr::map(dplyr::slice, 1) %>%
    dplyr::bind_rows() %>%
    dplyr::select(
      "do_id" = "doi",
      "pubmed_id" = "pmid",
      "first_author_last_name" = "lastname",
      "title"
    )

  iatlas.data::synapse_store_feather_file(
    dplyr::left_join(tbl, pubmed_tbl, by = "do_id"),
    "tcga_subtype_publications.feather",
    "syn22168316"
  )

}

