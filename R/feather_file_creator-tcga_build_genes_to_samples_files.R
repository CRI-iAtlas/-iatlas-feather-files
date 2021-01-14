tcga_build_genes_to_samples_files <- function() {

  gene_types <- c(
    "cellimage_network",
    "extracellular_network",
    "io_target",
    "immunomodulator"
  )

  genes <- "syn22162918" %>%
    synapse_feather_id_to_tbl(.) %>%
    dplyr::filter(.data$gene_type %in% gene_types) %>%
    dplyr::pull("entrez") %>%
    unique() %>%
    sort()

  expression <- "syn23560243" %>%
    synapse_feather_id_to_tbl(.) %>%
    dplyr::select("entrez", "sample", "rna_seq_expr") %>%
    tidyr::drop_na() %>%
    dplyr::filter(.data$entrez %in% genes)

  iatlas.data::synapse_store_feather_file(
    expression,
    "tcga_genes_to_samples.feather",
    "syn22125645"
  )

}
