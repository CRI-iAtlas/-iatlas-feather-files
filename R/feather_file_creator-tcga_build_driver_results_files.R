tcag_build_driver_results_files <- function() {

  get_results <- function() {

    tcga_genes <- iatlas.data::synapse_feather_id_to_tbl("syn22133677") %>%
      dplyr::filter(!is.na(hgnc))

    new_genes <- iatlas.data::synapse_feather_id_to_tbl("syn22240716") %>%
      dplyr::filter(!is.na(hgnc)) %>%
      dplyr::select("entrez", "hgnc")

    genes <-
      dplyr::bind_rows(
        tcga_genes,
        dplyr::filter(new_genes, !hgnc %in% tcga_genes$hgnc)
      )

    tcga_tags <- "syn23545011" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::select("tag" = "old_name", "new_tag" = "name") %>%
      tidyr::drop_na()

    driver_results <- "syn22126068" %>%
      synapse_rds_id_tbl() %>%
      dplyr::select(
        "label",
        "feature" = "metric",
        "tag" = "group2",
        "fold_change",
        "log10_p_value" = "log10_pvalue",
        "log10_fold_change",
        "p_value" = "pvalue",
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
      dplyr::mutate("mutation_code" = ifelse(
        is.na(mutation_code),
        "(NS)",
        mutation_code
      )) %>%
      dplyr::mutate("feature" = stringr::str_replace_all(.data$feature, "[\\.]", "_")) %>%
      dplyr::left_join(genes, by = "hgnc") %>%
      dplyr::select(-c("hgnc", "label")) %>%
      dplyr::select("entrez", "feature", "mutation_code", "tag", dplyr::everything()) %>%
      dplyr::distinct() %>%
      dplyr::mutate(dataset = "TCGA") %>%
      dplyr::inner_join(tcga_tags, by = "tag") %>%
      dplyr::select(-"tag") %>%
      dplyr::rename("tag" = "new_tag")

    return(driver_results)
  }

  iatlas.data::synapse_store_feather_file(
    get_results(),
    "driver_results.feather",
    "syn22126168"
  )

}
