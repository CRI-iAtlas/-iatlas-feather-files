pcawg_build_tags_to_tags_files <- function() {

  iatlas.data::create_global_synapse_connection()

  get_tags_to_tags <- function() {

    cat(crayon::magenta(paste0("Get pcawg tags_to_tags.")), fill = TRUE)

    tags_to_tags <- get_pcawg_tags_from_synapse() %>%
      dplyr::select(tag = dcc_project_code) %>%
      dplyr::distinct() %>%
      dplyr::mutate(related_tag = "PCAWG_Study") %>%
      dplyr::add_row(tag = "PCAWG_Study", related_tag = "PCAWG")
    return(tags_to_tags)
  }

  .GlobalEnv$pcawg_samples_to_tags <- iatlas.data::synapse_store_feather_file(
    get_tags_to_tags(),
    "pcawg_tags_to_tags.feather",
    "syn22125980"
  )

  ### Clean up ###
  # Data
  rm(pcawg_tags_to_tags, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
