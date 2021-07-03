build_cohorts_table <- function(){

  tbl <- dplyr::tribble(
    ~name,                  ~dataset, ~tag,             ~clinical,
    "TCGA",                 "TCGA",   NA,               NA,
    "TCGA_Immune_Subtype",  "TCGA",   "Immune_Subtype", NA,
    "TCGA_TCGA_Subtype",    "TCGA",   "TCGA_Subtype",   NA,
    "TCGA_TCGA_Study",      "TCGA",   "TCGA_Study",     NA,
    "TCGA_Gender",          "TCGA",   NA,               "Gender",
    "TCGA_Race",            "TCGA",   NA,               "Race",
    "TCGA_Ethnicity",       "TCGA",   NA,               "Ethnicity",
    "PCAWG",                "PCAWG",  NA,               NA,
    "PCAWG_Immune_Subtype", "PCAWG",  "Immune_Subtype", NA,
    "PCAWG_PCAWG_Study",    "PCAWG",  "PCAWG_Study",    NA,
    "PCAWG_Gender",         "PCAWG",  NA,               "Gender"
  )

  iatlas.data::synapse_store_feather_file(
    tbl,
    "cohorts.feather",
    "syn25617780"
  )
}

