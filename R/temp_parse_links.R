# doi_pattern <- "^https://doi.org/([:print:]+$)"
#
# get_nature_doid <- function(link){
#   print(link)
#   link %>%
#     curl::curl_fetch_memory() %>%
#     purrr::pluck("content") %>%
#     rawToChar() %>%
#     stringr::str_match_all(., '(https://doi.org/[:print:]+?/nature[:digit:]+)') %>%
#     unlist() %>%
#     unique()
# }
#
# tbl <- "syn22140514" %>%
#   iatlas.data::synapse_feather_id_to_tbl() %>%
#   dplyr::filter(sample_group == "Subtype_Curated_Malta_Noushmehr_et_al") %>%
#   dplyr::select("temp" = "Characteristics") %>%
#   dplyr::distinct() %>%
#   tidyr::separate("temp", " ; ", into = c("temp", "link"), extra = "merge") %>%
#   tidyr::separate("temp", " ", into = c("journal1", "journal2", "year"), fill = "left") %>%
#   tidyr::unite("journal", "journal1", "journal2", sep = " ", na.rm = T) %>%
#   dplyr::mutate("journal" = stringr::str_to_title(journal)) %>%
#   dplyr::arrange(journal) %>%
#   dplyr::mutate("doID" = dplyr::if_else(
#     stringr::str_detect(link, doi_pattern),
#     stringr::str_match(link, doi_pattern)[,2],
#     dplyr::if_else(
#       .data$journal == "Nature",
#       get_nature_doid(link),
#       NA_character_
#     )
#   ))
#
#
# req <- curl::curl_fetch_memory("http://www.nature.com/nature/journal/v497/n7447/full/nature12113.html")
# raw <- rawToChar(req$content)
# stringr::str_match_all(raw, '(https://doi.org/[:print:]+?)"')[[1]][,2][[1]]
