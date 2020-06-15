build_genes_synapse_table <- function(){
  require(magrittr)

  wolf <- iatlas.data::synapse_delimited_id_to_tbl("syn22151547")
  yasin <- iatlas.data::synapse_delimited_id_to_tbl("syn22151548")

  tbl <-
    dplyr::bind_rows(wolf, yasin) %>%
    dplyr::select("name" = "GeneSet") %>%
    dplyr::distinct() %>%
    tidyr::drop_na() %>%
    dplyr::mutate("name" = stringr::str_replace_all(name, "[ \\.]", "_")) %>%
    dplyr::mutate(
      "display" = stringr::str_to_title(stringr::str_replace_all(name, "_", " "))
    ) %>%
    dplyr::add_row(
      name = c("extra_cellular_network", "immunomodulator", "io_target", "cellimage_network", "potential_immunomodulator"),
      display = c("Extra Cellular Network", "Immunomodulator", "IO Target", "Cellimage Network", "Potential Immunomodulator")
    ) %>%
    dplyr::arrange(name)

  iatlas.data::synapse_store_feather_file(
    tbl,
    "gene_types.feather",
    "syn22130910"
  )

}

