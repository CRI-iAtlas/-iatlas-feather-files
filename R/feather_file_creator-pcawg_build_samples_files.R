pcawg_build_samples_files <- function() {

  require(magrittr)

  get_samples <- function() {

    cat(crayon::magenta(paste0("Get PCAWG samples.")), fill = TRUE)

    samples <- iatlas.data::get_pcawg_samples_cached() %>%
      dplyr::select(patient_barcode = sample) %>%
      dplyr::mutate("name" = patient_barcode, "dataset" = "PCAWG") %>%
      dplyr::arrange(name)

    return(samples)
  }

  iatlas.data::synapse_store_feather_file(
    get_samples(),
    "pcawg_samples.feather",
    "syn22125724"
  )
}
