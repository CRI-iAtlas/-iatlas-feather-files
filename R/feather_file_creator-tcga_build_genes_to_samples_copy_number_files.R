tcga_build_genes_to_samples_copy_number_files <- function() {

  cat_results_status <- function(message) {
    cat(crayon::cyan(paste0(" - ", message)), fill = TRUE)
  }

  get_cn <- function() {

    all_genes <- "syn22162880" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::pull("entrez")

    tcga_hgnc_to_entrez <- iatlas.data::synapse_feather_id_to_tbl("syn22133677") %>%
      tidyr::drop_na() %>%
      dplyr::filter(.data$entrez %in% all_genes)

    tcga_samples <- "syn22139885" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::pull("name")

    cn_tbl <- "syn22889333" %>%
      synapse_delimited_id_to_tbl() %>%
      dplyr::select(-'Locus ID', -'Cytoband') %>%
      dplyr::rename_with(~stringr::str_sub(.x, 1, 12)) %>%
      dplyr::rename("hgnc" = "Gene Symbol") %>%
      dplyr::inner_join(tcga_hgnc_to_entrez, by = "hgnc") %>%
      dplyr::select(-"hgnc") %>%
      dplyr::select(c("entrez", 1:1000)) %>%
      tidyr::pivot_longer(
        -"entrez", names_to = "sample", values_to = "copy_number"
      )
  }


}
