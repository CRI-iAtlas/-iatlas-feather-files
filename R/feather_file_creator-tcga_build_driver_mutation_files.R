tcga_build_mutations_files <- function() {
  require(magrittr)

  get_samples_to_mutations <- function() {

    gene_ids <- synapse_read_all_feather_files("syn22125640") %>%
      dplyr::select("hgnc", "entrez")

    samples_to_mutations <- "syn22131029" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::rename(sample = ParticipantBarcode) %>%
      tidyr::pivot_longer(
        -"sample",
        values_to = "status",
        names_to = "mutation"
      ) %>%
      tidyr::separate(
        "mutation",
        into = c("hgnc", "code"),
        sep = " ",
        fill = "right"
      ) %>%
      dplyr::distinct() %>%
      dplyr::mutate(
        "code" = dplyr::if_else(
          is.na(.data$code),
          "(NS)",
          .data$code
        ),
        "mutation" = stringr::str_c(.data$hgnc, ":", .data$code),
        "type" = "driver_mutation"
      ) %>%
      dplyr::inner_join(gene_ids, by = "hgnc") %>%
      dplyr::select(-"hgnc") %>%
      tidyr::drop_na()

    return(samples_to_mutations)
  }

  get_mutations <- function(sample_to_mutations){
    mutations <- sample_to_mutations %>%
      dplyr::select("name" = "mutation","entrez","code", "type") %>%
      dplyr::distinct() %>%
      dplyr::arrange(entrez, code)
    return(mutations)
  }

  get_mutation_codes <- function(mutations){
    mutation_codes <- mutations %>%
      dplyr::select("code") %>%
      dplyr::distinct()
    return(mutation_codes)
  }

  samples_to_mutations <-  get_samples_to_mutations()
  mutations <- get_mutations(samples_to_mutations)
  codes <- get_mutation_codes(mutations)
  samples_to_mutations <- samples_to_mutations %>%
    dplyr::select("sample", "mutation", "status")


  iatlas.data::synapse_store_feather_file(
    samples_to_mutations,
    "tcga_samples_to_mutations.feather",
    "syn22140071"
  )

  iatlas.data::synapse_store_feather_file(
    mutations,
    "tcga_mutations.feather",
    "syn22139702"
  )

  iatlas.data::synapse_store_feather_file(
    codes,
    "tcga_mutation_codes.feather",
    "syn22131021"
  )

}
