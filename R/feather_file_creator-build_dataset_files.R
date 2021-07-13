build_dataset_table <- function(){
  require(magrittr)

  tbl <-
    dplyr::tibble("display" = character(), type = character()) %>%
    dplyr::add_row("display" = c("TCGA", "PCAWG"), "type" = "analysis") %>%
    dplyr::add_row("display" = c("GTEX"), "type" = "other") %>%
    dplyr::mutate("name" = stringr::str_replace_all(.data$display, " ", "_"))

  iatlas.data::synapse_store_feather_file(
    tbl,
    "datasets.feather",
    "syn22165541"
  )
}

