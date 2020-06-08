pcawg_build_tags_files <- function() {

  iatlas.data::create_global_synapse_connection()



  get_tags <- function() {

    cat(crayon::magenta(paste0("Get PCAWG tags.")), fill = TRUE)

    tags <- iatlas.data::get_pcawg_tag_values_cached() %>%
      dplyr::select(name = tag) %>%
      dplyr::distinct() %>%
      dplyr::filter(!stringr::str_detect(name, "C[:digit:]")) %>%
      dplyr::filter(name != "PCAWG") %>%
      dplyr::mutate("display" = name, "type" = "group") %>%
      dplyr::add_row(name = "PCAWG", display = "PCAWG") %>%
      dplyr::add_row(name = "PCAWG_Study", display = "PCAWG Study") %>%
      dplyr::arrange(name)

    return(tags)
  }

  # Setting these to the GlobalEnv just for development purposes.

  .GlobalEnv$pcawg_samples_to_tags <- iatlas.data::synapse_store_feather_file(
    get_tags(),
    "pcawg_tags.feather",
    "syn22125978"
  )

  ### Clean up ###
  # Data
  rm(pcawg_tags, pos = ".GlobalEnv")
  cat("Cleaned up.", fill = TRUE)
  gc()
}
