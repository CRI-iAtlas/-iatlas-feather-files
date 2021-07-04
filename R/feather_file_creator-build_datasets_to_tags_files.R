build_genes_synapse_table <- function(){
  require(magrittr)

  tbl <- dplyr::tribble(
    ~tag,             ~dataset,
    "Immune_Subtype", "TCGA",
    "TCGA_Subtype",   "TCGA",
    "TCGA_Study",     "TCGA",
    "gender",         "TCGA",
    "race",           "TCGA",
    "ethnicity",      "TCGA",
    "Immune_Subtype", "PCAWG",
    "PCAWG_Study",    "PCAWG",
    "gender",         "PCAWG"
  )


  iatlas.data::synapse_store_feather_file(
    tbl,
    "datasets_to_tags.feather",
    "syn22166402"
  )

}

