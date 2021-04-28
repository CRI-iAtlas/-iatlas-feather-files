build_cohorts_table <- function(){

  tbl <- dplyr::tribble(
    ~name,                  ~dataset, ~tag,             ~clinical,
    "tcga_immune_subtype",  "tcga",   "Immune_Subtype", NA,
    "tcga_tcga_subtype",    "tcga",   "TCGA_Subtype",   NA,
    "tcga_tcga_study",      "tcga",   "TCGA_Study",     NA,
    "tcga_gender",          "tcga",   NA,               "Gender",
    "tcga_race",            "tcga",   NA,               "Race",
    "tcga_ethnicity",       "tcga",   NA,               "Ethnicity",
    "pcawg_immune_subtype", "pcawg", "Immune_Subtype",  NA,
    "pcawg_pcawg_study",    "pcawg", "PCAWG_Study",     NA,
    "pcawg_gender",         "pcawg", NA,                "Gender"
  )

  iatlas.data::synapse_store_feather_file(
    tbl,
    "cohorts.feather",
    "syn25617780"
  )
}

