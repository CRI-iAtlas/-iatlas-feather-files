tcga_build_mutations_files <- function() {
  require(magrittr)

  get_mutations <- function() {

    cat(crayon::magenta(paste0("Get mutations")), fill = TRUE)

    tcga_gene_ids <- "syn22133677" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      tidyr::drop_na()

    new_gene_ids <- "syn21788372" %>%
      iatlas.data::synapse_delimited_id_to_tbl(.) %>%
      dplyr::select("hgnc", "entrez")

    gene_ids <- dplyr::bind_rows(
      tcga_gene_ids,
      dplyr::filter(new_gene_ids, !hgnc %in% tcga_gene_ids$hgnc)
    )

    mutations <- "syn22131029" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
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
      dplyr::distinct() %>%
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
