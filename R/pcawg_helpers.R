get_pcawg_sample_tbl_cached <- function(){
  synapser::synLogin()
  iatlas.data::result_cached(
    "pcawg_sample_tbl",
    "syn21785582" %>%
      synapser::synGet() %>%
      purrr::pluck("path") %>%
      read.csv(sep = "\t", stringsAsFactors = F) %>%
      dplyr::as_tibble()
  )
}

get_pcawg_samples_cached <- function(){
  iatlas.data::result_cached(
    "pcawg_sample_tbl",
    get_pcawg_sample_tbl_cached() %>%
      dplyr::select(sample = icgc_donor_id) %>%
      dplyr::mutate(patient = sample)
  )
}

get_pcawg_tag_values_cached <- function(){
  iatlas.data::result_cached(
    "pcawg_tag_values",
    get_pcawg_tags_from_synapse() %>%
      tidyr::pivot_longer(-sample, values_to = "tag") %>%
      dplyr::select(-name)
  )
}

