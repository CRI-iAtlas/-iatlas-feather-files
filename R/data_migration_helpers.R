get_tcga_gene_ids <- function() {
  iatlas.data::result_cached(
    "gene_ids",
    synapse_feather_id_to_tbl("syn22133677")
  )
    # feather::read_feather("feather_files/genes/master_gene_ids.feather") %>% dplyr::as_tibble())
}

# get_known_gene_resolutions <- function() {
#   iatlas.data::result_cached(
#     "known_gene_resolutions",
#     feather::read_feather("feather_files/known_gene_resolutions.feather") %>% dplyr::as_tibble())
# }

# resolve_hgnc_conflicts <- function(genes) {
#   genes %>% dplyr::left_join(get_known_gene_resolutions(), by = c("entrez")) %>%
#     dplyr::rowwise() %>%
#     dplyr::mutate(hgnc = ifelse(identical(hgnc, alias), official, hgnc)) %>%
#     dplyr::select(-c(alias, official))
# }

driver_results_label_to_hgnc <- function(label) {
  hgnc <- label %>% stringi::stri_extract_first(regex = "^[\\w\\s\\(\\)\\*\\-_\\?\\=]{1,}(?!=;)")
  return(ifelse(
    !identical(hgnc, "NA") & !is.na(hgnc),
    hgnc,
    NA
  ))
}


