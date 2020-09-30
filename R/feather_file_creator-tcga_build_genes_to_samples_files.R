tcga_build_genes_to_samples_files <- function() {

  cat_results_status <- function(message) {
    cat(crayon::cyan(paste0(" - ", message)), fill = TRUE)
  }

  get_genes_to_samples <- function() {

    all_genes <- "syn22162880" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::pull("entrez")

    tcga_hgnc_to_entrez <- iatlas.data::synapse_feather_id_to_tbl("syn22133677") %>%
      tidyr::drop_na() %>%
      dplyr::filter(.data$entrez %in% all_genes) %>%
      dplyr::mutate("entrez" = as.integer(.data$entrez))

    tcga_samples <- "syn22139885" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::pull("name")

    tcga_aliquots <- "syn21435422" %>%
      synapse_delimited_id_to_tbl() %>%
      dplyr::rename("patient" = 1, "aliqout" = 2) %>%
      tidyr::drop_na() %>%
      dplyr::pull("aliqout")

    expression <- "syn22890627" %>%
      synapse_delimited_id_to_tbl() %>%
      tidyr::separate("gene_id", sep = "\\|", into = c("hgnc", "entrez")) %>%
      dplyr::mutate("entrez" = as.integer(.data$entrez)) %>%
      dplyr::select(-"hgnc") %>%
      dplyr::filter(.data$entrez %in% all_genes) %>%
      dplyr::select(dplyr::any_of(c("entrez", tcga_aliquots))) %>%
      dplyr::rename_with(~stringr::str_sub(.x, 1, 12)) %>%
      dplyr::select(dplyr::any_of(c("entrez", tcga_samples[1:65]))) %>%
      tidyr::pivot_longer(
        -"entrez", names_to = "sample", values_to = "rna_seq_expr"
      ) %>%
      tidyr::drop_na()

    copy_number <- "syn22889333" %>%
      synapse_delimited_id_to_tbl() %>%
      dplyr::select(-'Locus ID', -'Cytoband') %>%
      dplyr::rename_with(~stringr::str_sub(.x, 1, 12)) %>%
      dplyr::rename("hgnc" = "Gene Symbol") %>%
      dplyr::inner_join(tcga_hgnc_to_entrez, by = "hgnc") %>%
      dplyr::select(dplyr::any_of(c("entrez", tcga_samples[1:65]))) %>%
      tidyr::pivot_longer(
        -"entrez", names_to = "sample", values_to = "copy_number"
      ) %>%
      tidyr::drop_na()

    dplyr::full_join(expression, copy_number, by = c("entrez", "sample"))
  }

  .GlobalEnv$pcawg_genes_to_samples <- iatlas.data::synapse_store_feather_file(
    get_genes_to_samples(),
    "tcga_genes_to_samples.feather",
    "syn22891553"
  )



}
