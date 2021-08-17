build_genes_types_file <- function(){
  require(magrittr)

  wolf <- iatlas.data::synapse_delimited_id_to_tbl("syn22240714")
  yasin <- iatlas.data::synapse_delimited_id_to_tbl("syn22240715")

  genesets <- dplyr::tribble(
    ~name,                            ~display,
    "extracellular_network",          "Extra Cellular Network",
    "cellimage_network",              "Cellimage Network",
    "immunomodulator",                "Immunomodulator",
    "io_target",                      "IO Target",
    "potential_immunomodulator",      "Potential Immunomodulator",
    "cibersort_gene",                 "Cibersort Gene",
    "mcpcounter_gene",                "MCPcounter Gene",
    "epic_gene",                      "Epic Gene",
    "immune_subtype_classifier_gene", "Immune Subtype Classifier Gene"
  )

  tbl <-
    dplyr::bind_rows(wolf, yasin) %>%
    dplyr::select("name" = "GeneSet") %>%
    dplyr::distinct() %>%
    tidyr::drop_na() %>%
    dplyr::mutate("name" = stringr::str_replace_all(name, "[ \\.]", "_")) %>%
    dplyr::mutate(
      "display" = stringr::str_to_title(stringr::str_replace_all(name, "_", " "))
    ) %>%
    dplyr::arrange(name) %>%
    dplyr::bind_rows(genesets, .)

  iatlas.data::synapse_store_feather_file(
    tbl,
    "gene_types.feather",
    "syn22130910"
  )

}

