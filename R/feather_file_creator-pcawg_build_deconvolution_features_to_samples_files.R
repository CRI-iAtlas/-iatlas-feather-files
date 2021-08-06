pcawg_build_deconvolution_features_to_samples_files <- function() {

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030474"),
    "pcawg_cibersort.feather",
    "syn22125635"
  )

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030518"),
    "pcawg_epic.feather",
    "syn22125635"
  )

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030514"),
    "pcawg_mcpcounter.feather",
    "syn22125635"
  )

}
