tcga_build_mutation_codes_files <- function() {

  get_codes <- function() {
    cat(crayon::magenta(paste0("Get mutation_codes.")), fill = TRUE)

    create_global_synapse_connection()

    mutation_codes <- "syn22131029" %>%
      .GlobalEnv$synapse$get() %>%
      purrr::pluck("path") %>%
      feather::read_feather(.) %>%
      dplyr::select(-"ParticipantBarcode") %>%
      colnames() %>%
      unique() %>%
      dplyr::tibble("code" = .) %>%
      tidyr::separate(
        "code", into = c("gene", "code"), sep = " ", fill = "right"
      ) %>%
      dplyr::select("code") %>%
      dplyr::distinct() %>%
      tidyr::drop_na() %>%
      dplyr::add_row("code" = "(NS)") %>%
      dplyr::arrange(code)

    return(mutation_codes)
  }

  .GlobalEnv$tcga_mutation_codes <- iatlas.data::synapse_store_feather_file(
    get_codes(),
    "tcga_mutation_codes.feather",
    "syn22131021"
  )

  ### Clean up ###
  rm(tcga_mutation_codes, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
