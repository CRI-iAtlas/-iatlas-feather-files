build_tcga_immunomodulator_publications <- function(){

  tbl <- iatlas.data::synapse_feather_id_to_tbl("syn23518433")

  iatlas.data::synapse_store_feather_file(
    tbl,
    "tcga_immunomodulator_publications.feather",
    "syn22168316"
  )
}

