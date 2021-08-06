tcag_build_deconvolution_features_to_samples_files <- function() {

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26031358"),
    "tcga_cibersort.feather",
    "syn22125635"
  )

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030519"),
    "tcga_epic.feather",
    "syn22125635"
  )

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030516"),
    "tcga_mcpcounter.feather",
    "syn22125635"
  )
}
