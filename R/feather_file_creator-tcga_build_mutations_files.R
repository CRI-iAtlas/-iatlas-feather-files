tcga_build_mutations_files <- function() {
  iatlas.data::create_global_synapse_connection()

  get_mutations <- function() {

    cat(crayon::magenta(paste0("Get mutations")), fill = TRUE)

    tcga_gene_ids <- "syn22133677" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
      tidyr::drop_na()

    new_gene_ids <- "syn21788372" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      readr::read_tsv(.) %>%
      dplyr::select("hgnc", "entrez")

    gene_ids <- dplyr::bind_rows(
      tcga_gene_ids,
      dplyr::filter(new_gene_ids, !entrez %in% tcga_gene_ids$entrez)
    )

    mutations <- "syn22131029" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
      dplyr::select(-"ParticipantBarcode") %>%
      colnames() %>%
      unique() %>%
      dplyr::tibble("code" = .) %>%
      tidyr::separate(
        "code", into = c("hgnc", "code"), sep = " ", fill = "right"
      ) %>%
      dplyr::distinct() %>%
      dplyr::mutate(code = dplyr::if_else(is.na(code), "(NS)", code)) %>%
      dplyr::left_join(gene_ids, by = "hgnc") %>%
      dplyr::select("entrez", "code") %>%
      dplyr::mutate("type" = "driver_mutation") %>%
      dplyr::arrange(entrez, code)

    return(mutations)
  }

  .GlobalEnv$tcga_mutations <- iatlas.data::synapse_store_feather_file(
    get_mutations(),
    "tcga_mutation.feather",
    "syn22139702"
  )

  ### Clean up ###
  # Data
  rm(tcga_mutations, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
