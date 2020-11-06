tcag_build_copy_number_results_files <- function() {

  require(magrittr)


  entrez_ids <- "syn22240716" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::filter(!is.na(hgnc)) %>%
    dplyr::pull("entrez")

  copy_number_results <- iatlas.data::get_tcga_copynumber_results_cached()

  tcga_tags <- "syn23545011" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("tag" = "old_name", "new_tag" = "name") %>%
    tidyr::drop_na()

  copy_number_results_formated <- copy_number_results %>%
    dplyr::distinct(
      entrez,
      feature,
      tag,
      direction,
      mean_normal,
      mean_cnv,
      p_value,
      log10_p_value,
      t_stat
    ) %>%
    dplyr::filter(entrez %in% entrez_ids) %>%
    dplyr::inner_join(tcga_tags, by = "tag") %>%
    dplyr::select(-"tag") %>%
    dplyr::rename("tag" = "new_tag") %>%
    dplyr::arrange(entrez, feature, tag, direction) %>%
    dplyr::mutate(dataset = "TCGA")

  iatlas.data::synapse_store_feather_file(
    copy_number_results_formated,
    "tcga_copy_number_results.feather",
    "syn22125983"
  )
}
