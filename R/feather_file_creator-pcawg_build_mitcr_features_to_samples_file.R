pcawg_build_mitcr_features_to_samples_file <- function() {

  synapser::synLogin()

  names_tbl <- get_pcawg_sample_tbl_cached() %>%
    dplyr::select(icgc_sample_id, icgc_donor_id)

  synapse_id_to_tbl2 <- function(id) {
    id %>%
      synapser::synGet() %>%
      purrr::pluck("path") %>%
      jsonlite::fromJSON() %>%
      dplyr::as_tibble()
  }

  tbl <- "select id from syn20693185" %>%
    synapser::synTableQuery(includeRowIdAndRowVersion = F) %>%
    purrr::pluck("filepath") %>%
    readr::read_csv() %>%
    dplyr::mutate(tbl = purrr::map(id, synapse_id_to_tbl2)) %>%
    dplyr::select(tbl) %>%
    tidyr::unnest(cols = tbl) %>%
    dplyr::inner_join(names_tbl, by = c("sample" = "icgc_sample_id")) %>%
    dplyr::select(-sample) %>%
    dplyr::select(
      sample = icgc_donor_id, TCR_Shannon, TCR_Richness, TCR_Evenness
    ) %>%
    tidyr::pivot_longer(-sample, values_to = "value", names_to = "feature")

  iatlas.data::synapse_store_feather_file(
    tbl,
    "pcawg_mitcr.feather",
    "syn22125635"
  )

}
