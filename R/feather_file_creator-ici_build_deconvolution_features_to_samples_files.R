ici_build_deconvolution_features_to_samples_files <- function() {

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030510"),
    "ici_cibersort.feather",
    "syn22125635"
  )

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030520"),
    "ici_epic.feather",
    "syn22125635"
  )

  synapse_store_feather_file(
    synapse_feather_id_to_tbl("syn26030517"),
    "ici_mcpcounter.feather",
    "syn22125635"
  )

}
