build_tcga_immunomodulator_publication_to_gene_to_gene_types <- function(){

  require(magrittr)
  require(rlang)

  pub_tbl <- "syn23518433" %>%
    iatlas.data::synapse_feather_id_to_tbl() %>%
    dplyr::select("pubmed_id", "publication_name" = "name")

  pub_entrez_tbl <- "syn23518445" %>%
    iatlas.data::synapse_feather_id_to_tbl() %>%
    dplyr::left_join(pub_tbl, by = "pubmed_id") %>%
    dplyr::select("entrez", "publication_name") %>%
    dplyr::mutate("gene_type" = "immunomodulator")

  iatlas.data::synapse_store_feather_file(
    pub_entrez_tbl,
    "tcga_immunomodulator_publications_to_genes_to_gene_types.feather",
    "syn22234818"
  )
}

