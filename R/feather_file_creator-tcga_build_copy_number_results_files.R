tcag_build_copy_number_results_files <- function() {

  require(magrittr)

  cat_results_status <- function(message) {
    cat(crayon::cyan(paste0(" - ", message)), fill = TRUE)
  }

  get_results <- function() {
    cat(crayon::magenta(paste0("Get driver results")), fill = TRUE)

    entrez_ids <- "syn22240716" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::filter(!is.na(hgnc)) %>%
      dplyr::pull("entrez")

    cat_results_status("Get the initial values from the copy_number_results table.")
    copy_number_results <- iatlas.data::get_tcga_copynumber_results_cached()

    cat_results_status("Clean up the data set.")
    copy_number_results <- copy_number_results %>%
      dplyr::distinct(entrez, feature, tag, direction, mean_normal, mean_cnv, p_value, log10_p_value, t_stat) %>%
      dplyr::arrange(entrez, feature, tag, direction) %>%
      dplyr::mutate(dataset = "TCGA") %>%
      dplyr::filter(entrez %in% entrez_ids)

    return(copy_number_results)
  }

  .GlobalEnv$pcawg_samples_to_tags <- iatlas.data::synapse_store_feather_file(
    get_results(),
    "tcga_copy_number_results.feather",
    "syn22125983"
  )
}
