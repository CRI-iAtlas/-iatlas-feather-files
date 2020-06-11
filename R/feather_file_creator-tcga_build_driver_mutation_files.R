tcga_build_mutations_files <- function() {
  require(magrittr)

  get_samples_to_mutations <- function() {

    cat(crayon::magenta(paste0("Get driver samples to mutations")), fill = TRUE)

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

    cat(crayon::magenta(paste0("make driver samples to mutations")), fill = TRUE)

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
      dplyr::mutate(mutation_code = dplyr::if_else(
        is.na(mutation_code),
        "(NS)",
        mutation_code
      )) %>%
      tidyr::drop_na() %>%
      dplyr::left_join(gene_ids, by = "hgnc") %>%
      dplyr::select(-"hgnc") %>%
      dplyr::mutate("mutation_type" = "driver_mutation")

    return(samples_to_mutations)
  }

  get_mutations <- function(sample_to_mutations){

    cat(crayon::magenta(paste0("make driver mutations")), fill = TRUE)


    mutations <- sample_to_mutations %>%
      dplyr::select(
        "entrez",
        "code" = "mutation_code",
        "type" = "mutation_type"
      ) %>%
      dplyr::distinct() %>%
      dplyr::arrange(entrez, code)
    return(mutations)
  }

  get_mutation_codes <- function(mutations){
    cat(crayon::magenta(paste0("make driver mutation codes")), fill = TRUE)

    mutation_codes <- mutations %>%
      dplyr::select("code") %>%
      dplyr::distinct()
    return(mutation_codes)
  }

  samples_to_mutations <-  get_samples_to_mutations()

  iatlas.data::synapse_store_feather_file(
    samples_to_mutations,
    "tcga_samples_to_mutations.feather",
    "syn22140071"
  )

  mutations <- get_mutations(samples_to_mutations)

  iatlas.data::synapse_store_feather_file(
    mutations,
    "tcga_mutations.feather",
    "syn22139702"
  )

  iatlas.data::synapse_store_feather_file(
    get_mutation_codes(mutations),
    "tcga_mutation_codes.feather",
    "syn22131021"
  )

  ### Clean up ###
  # Data
  rm(tcga_mutations, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
