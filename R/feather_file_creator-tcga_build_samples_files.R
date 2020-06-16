tcga_build_samples_files <- function() {

  require(magrittr)

  get_samples <- function() {

    cat(crayon::magenta(paste0("Get samples.")), fill = TRUE)

    samples <- "syn22128019" %>%
      iatlas.data::synapse_feather_id_to_tbl() %>%
      dplyr::select("name" = "ParticipantBarcode") %>%
      dplyr::mutate("patient_barcode" = name, "dataset" = "TCGA") %>%
      dplyr::arrange(name)

    return(samples)
  }

  iatlas.data::synapse_store_feather_file(
    get_samples(),
    "tcga_samples.feather",
    "syn22125724"
  )
}
