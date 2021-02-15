coloc <- function(){
  require(magrittr)

  gwas <-
    "syn24298976" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select(
      "feature" = "name",
      "category" = "Annot.Figure.ImmuneCategory",
      "module" = "Annot.Figure.ImmuneModule",
      "snp" = "snp_col",
      "p_value" = "PLINK.P",
      "maf"
    ) %>%
    dplyr::mutate("dataset" = "TCGA")

  #category module nullable

  snps <-
    "syn24298976" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::select(
      "name" = "snp_col",
      "rsid" = "snp_id",
      "chr" = "chr_col",
      "bp" = "bp_col",
    ) %>%
    dplyr::distinct() %>%
    dplyr::mutate("rsid" = dplyr::if_else(
      .data$rsid == "NA",
      NA_character_,
      .data$rsid
    ))

  # snps rsid nullable


  genes <- "syn22240716" %>%
    synapse_feather_id_to_tbl()

  coloc_gtex <- "syn24202047" %>%
    synapse_feather_id_to_tbl()

  # keys: feature, snp, qtl, gene, splice, tissue


  coloc_tcga <- "syn24202048" %>%
    synapse_feather_id_to_tbl()

  # keys: feature, snp, qtl, gene, splice, c1c2, plotype

  coloc <-
    dplyr::bind_rows(
      "syn24202048" %>%
        synapse_feather_id_to_tbl() %>%
        dplyr::mutate("source" = "TCGA"),
      "syn24202048" %>%
        synapse_feather_id_to_tbl() %>%
        dplyr::mutate("source" = "GTEX"),
    ) %>%
    dplyr::rename("hgnc" = "gene") %>%
    dplyr::left_join(genes, by = "hgnc")

  missing_genes <- coloc %>%
    dplyr::filter(is.na(.data$entrez)) %>%
    dplyr::pull("hgnc") %>%
    unique()

  coloc <- coloc %>%
    dplyr::filter(!is.na(.data$entrez))

  rare_vars <- "syn24298988" %>%
    synapse_feather_id_to_tbl()



  # synapse_store_feather_file(gwas, "tcga_germline_GWAS.feather", "syn24202036")
  # synapse_store_feather_file(snps, "tcga_germline_GWAS_snps.feather", "syn24202034")
}



