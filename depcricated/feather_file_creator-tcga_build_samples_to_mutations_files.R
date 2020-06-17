tcga_build_samples_to_mutations_files <- function() {
  require(magrittr)

  get_samples_to_mutations <- function() {

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

    samples_to_mutations <- "syn22131029" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::rename(sample = ParticipantBarcode) %>%
      tidyr::pivot_longer(
        -"sample",
        values_to = "status",
        names_to = "mutation"
      ) %>%
      tidyr::separate(
        "mutation", into = c("hgnc", "mutation_code"), sep = " ", fill = "right"
      ) %>%
      dplyr::distinct() %>%
      dplyr::mutate(mutation_code = dplyr::if_else(is.na(mutation_code), "(NS)", mutation_code)) %>%
      tidyr::drop_na() %>%
      dplyr::left_join(gene_ids, by = "hgnc") %>%
      dplyr::select(-"hgnc") %>%
      dplyr::mutate("mutation_type" = "driver_mutation")


    return(samples_to_mutations)
  }

  .GlobalEnv$tcga_sample_to_mutations <- iatlas.data::synapse_store_feather_file(
    get_samples_to_mutations(),
    "tcga_samples_to_mutations.feather",
    "syn22140071"
  )


  ### Clean up ###
  # Data
  rm(tcga_sample_to_mutations, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
