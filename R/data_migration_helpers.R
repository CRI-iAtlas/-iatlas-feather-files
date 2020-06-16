get_tcga_gene_ids <- function() {
  iatlas.data::result_cached(
    "gene_ids",
    synapse_feather_id_to_tbl("syn22133677")
  )
}

get_gene_ids <- function() {
  iatlas.data::result_cached(
    "gene_ids",
    synapse_delimited_id_to_tbl("syn21788372") %>%
      dplyr::select("entrez", "hgnc")
  )
}

driver_results_label_to_hgnc <- function(label) {
  hgnc <- label %>% stringi::stri_extract_first(regex = "^[\\w\\s\\(\\)\\*\\-_\\?\\=]{1,}(?!=;)")
  return(ifelse(
    !identical(hgnc, "NA") & !is.na(hgnc),
    hgnc,
    NA
  ))
}


