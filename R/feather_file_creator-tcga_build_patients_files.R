tcga_build_patients_files <- function() {

  require(magrittr)
  require(rlang)

  get_patients <- function() {

    cat(crayon::magenta(paste0("Get patients.")), fill = TRUE)

    patients <- "syn22128019" %>%
      iatlas.data::synapse_feather_id_to_tbl(.) %>%
      dplyr::select(
        "barcode" = "ParticipantBarcode",
        "age_at_diagnosis" = "age_at_initial_pathologic_diagnosis",
        "ethnicity",
        "gender",
        "height",
        "race",
        "weight"
      ) %>%
      dplyr::mutate_at(c("ethnicity", "gender", "race"), ~tolower(.x)) %>%
      dplyr::mutate(
        "gender" = dplyr::if_else(
          .data$gender %in% c("female", "male"),
          .data$gender,
          NA_character_
        ),
        "ethnicity" = dplyr::if_else(
          .data$ethnicity %in% c("not hispanic or latino", "hispanic or latino"),
          .data$ethnicity,
          NA_character_
        ),
        "race" = dplyr::if_else(
          .data$race %in% c(
            "white",
            "black or african american",
            "asian",
            "native hawaiian or other pacific islander",
            "american indian or alaska native"
          ),
          .data$race,
          NA_character_
        )
      ) %>%
      dplyr::arrange(.data$barcode)

    return(patients)
  }

  iatlas.data::synapse_store_feather_file(
    get_patients(),
    "tcga_patients.feather",
    "syn22125717"
  )
}
