build_cohorts_table <- function(){

  tbl <- dplyr::tribble(
    ~name,                  ~dataset, ~tag,             ~clinical,
    "tcga_immune_subtype",  "TCGA",   "Immune_Subtype", NA,
    "tcga_tcga_subtype",    "TCGA",   "TCGA_Subtype",   NA,
    "tcga_tcga_study",      "TCGA",   "TCGA_Study",     NA,
    "tcga_gender",          "TCGA",   NA,               "Gender",
    "tcga_race",            "TCGA",   NA,               "Race",
    "tcga_ethnicity",       "TCGA",   NA,               "Ethnicity",
    "pcawg_immune_subtype", "PCAWG", "Immune_Subtype",  NA,
    "pcawg_pcawg_study",    "PCAWG", "PCAWG_Study",     NA,
    "pcawg_gender",         "PCAWG", NA,                "Gender"
  )

  iatlas.data::synapse_store_feather_file(
    tbl,
    "cohorts.feather",
    "syn25617780"
  )
}

