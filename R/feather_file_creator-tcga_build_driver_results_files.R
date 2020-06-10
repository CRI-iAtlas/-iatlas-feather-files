tcag_build_driver_results_files <- function() {

  cat_results_status <- function(message) {
    cat(crayon::cyan(paste0(" - ", message)), fill = TRUE)
  }

  get_results <- function() {

    tcga_genes <- synapse_feather_id_to_tbl("syn22125607") %>%
      dplyr::filter(!is.na(hgnc))

    new_genes <- synapse_dellimted_id_to_tbl("syn21788372") %>%
      dplyr::filter(!is.na(hgnc)) %>%
      dplyr::select("entrez", "hgnc")

    genes <-
      dplyr::bind_rows(
        tcga_genes,
        dplyr::filter(new_genes, !hgnc %in% tcga_genes$hgnc)
      )

    driver_results <- "syn22126068" %>%
      synapse_rds_id_tbl() %>%
      dplyr::select(
        "label",
        "feature" = "metric",
        "tag" = "group2",
        "fold_change",
        "log10_pvalue",
        "log10_fold_change",
        "pvalue",
        "n_wt",
        "n_mut"
      ) %>%
      dplyr::mutate(
        gene_mutation = iatlas.data::driver_results_label_to_hgnc(label)
      ) %>%
      tidyr::separate(
        gene_mutation,
        into = c("hgnc", "mutation_code"),
        sep = "\\s",
        remove = TRUE
      ) %>%
      dplyr::mutate(code = ifelse(
        is.na(mutation_code),
        "(NS)",
        mutation_code
      )) %>%
      dplyr::left_join(genes, by = "hgnc") %>%
      dplyr::select(-c("hgnc", "label")) %>%
      dplyr::select("entrez", "feature", "mutation_code", "tag", dplyr::everything()) %>%
      dplyr::distinct() %>%
      dplyr::mutate(dataset = "TCGA")

    return(driver_results)
  }

  .GlobalEnv$driver_results <- iatlas.data::synapse_store_feather_file(
    get_results(),
    "driver_results.feather",
    "syn22126168"
  )

  ### Clean up ###
  # Data
  rm(driver_results, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
