pcawg_build_genes_to_samples_files <- function() {

  require(magrittr)
  cat_genes_to_samples_status <- function(message) {
    cat(crayon::cyan(paste0(" - ", message)), fill = TRUE)
  }

  get_genes_to_samples <- function() {

    cat(crayon::magenta(paste0("Get PCAWG genes_to_samples.")), fill = TRUE)

    cat_genes_to_samples_status("Get the initial values from the genes_to_samples table.")

    hugo_to_entrez_tbl <- "syn22240716" %>%
      iatlas.data::synapse_feather_id_to_tbl(.)

    genes_to_samples <- "syn21785590" %>%
      synapse_delimited_id_to_tbl() %>%
      dplyr::rename("hgnc" = "gene") %>%
      dplyr::inner_join(hugo_to_entrez_tbl, by = "hgnc") %>%
      dplyr::select(-"hgnc") %>%
      tidyr::pivot_longer(-"entrez", names_to = "sample", values_to = "rna_seq_expr")

    return(genes_to_samples)
  }

  iatlas.data::synapse_store_feather_file(
    get_genes_to_samples(),
    "pcawg_genes_to_samples.feather",
    "syn22125645"
  )
}
