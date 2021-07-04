build_cohorts_table <- function(){

  tbl <- dplyr::tribble(
    ~name,                  ~dataset, ~tag,
    "TCGA",                 "TCGA",   NA,
    "TCGA_Immune_Subtype",  "TCGA",   "Immune_Subtype",
    "TCGA_TCGA_Subtype",    "TCGA",   "TCGA_Subtype",
    "TCGA_TCGA_Study",      "TCGA",   "TCGA_Study",
    "TCGA_Gender",          "TCGA",   "gender",
    "TCGA_Race",            "TCGA",   "race",
    "TCGA_Ethnicity",       "TCGA",   "ethnicity",
    "PCAWG",                "PCAWG",  NA,
    "PCAWG_Immune_Subtype", "PCAWG",  "Immune_Subtype",
    "PCAWG_PCAWG_Study",    "PCAWG",  "PCAWG_Study",
    "PCAWG_Gender",         "PCAWG",  "gender"
  )

  iatlas.data::synapse_store_feather_file(
    tbl,
    "cohorts.feather",
    "syn25617780"
  )
}

