pcawg_build_patients_files <- function() {
  synapser::synLogin()
  patient_clinical_data <- "syn24827063" %>%
    synapser::synGet() %>%
    purrr::pluck("path") %>%
    readxl::read_excel(.) %>%
    dplyr::select(
      "barcode" = "icgc_donor_id",
      "gender" = "donor_sex",
      "age_at_diagnosis" = "donor_age_at_diagnosis"
    )

  patients <- iatlas.data::get_pcawg_samples_cached() %>%
    dplyr::select(barcode = sample) %>%
    dplyr::left_join(patient_clinical_data)


  iatlas.data::synapse_store_feather_file(
    patients,
    "pcawg_patients.feather",
    "syn22125717"
  )
}
