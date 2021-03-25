coloc <- function(){
  require(magrittr)

  heritability <- "syn23651688" %>%
    synapse_feather_id_to_tbl()

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

  # keys: feature snp dataset

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

  coloc <-
    dplyr::bind_rows(
      "syn24202048" %>%
        synapse_feather_id_to_tbl() %>%
        dplyr::mutate("coloc_dataset" = "TCGA"),
      "syn24202047" %>%
        synapse_feather_id_to_tbl() %>%
        dplyr::mutate("coloc_dataset" = "GTEX"),
    ) %>%
    dplyr::select(-c("display", "snp_id", "chr", "bp")) %>%
    dplyr::rename(
      "snp" = "snp_col",
      "qtl_type" = "QTL",
      "splice_loc" = "splice",
      "plot_link" = "link_plot",
      "ecaviar_pp" = "C1C2"
    ) %>%
    dplyr::mutate(
      "dataset" = "TCGA",
      "splice_loc" = dplyr::if_else(
        .data$splice_loc == "",
        NA_character_,
        .data$splice_loc
      )
    )

  rv_pathway_associations <- "syn24298988" %>%
    synapse_feather_id_to_tbl() %>%
    dplyr::rename(
      "n_mutants" = "n_mutations",
      "n_total" = "n"
    ) %>%
    dplyr::select(-c("display", "germline_category", "germline_module")) %>%
    dplyr::mutate("dataset" = "TCGA")


  # keys feature pathway dataset

  germline_features <-
    dplyr::bind_rows(
      heritability,
      gwas,
      coloc,
      rv_pathway_associations
    ) %>%
    dplyr::select(
      "name" = "feature",
      "germline_category" = "category",
      "germline_module" = "module"
    ) %>%
    dplyr::distinct() %>%
    tidyr::drop_na() %>%
    dplyr::group_by(name) %>%
    dplyr::arrange(germline_category, germline_module) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup()

  # synapse_store_feather_file(
  #   rv_pathway_associations,
  #   "tcga_rare_variant_pathway_associations.feather",
  #   "syn24873865"
  # )
  # synapse_store_feather_file(germline_features, "tcga_germline_feature_cols.feather", "syn22125617")
  # synapse_store_feather_file(gwas, "tcga_germline_GWAS.feather", "syn24202036")
  # synapse_store_feather_file(snps, "tcga_germline_GWAS_snps.feather", "syn24202034")
}



