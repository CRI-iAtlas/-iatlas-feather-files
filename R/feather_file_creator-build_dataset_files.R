build_dataset_table <- function(){
  require(magrittr)

  tbl <- "syn21557455" %>%
    iatlas.data::synapse_feather_id_to_tbl(.) %>%
    dplyr::select("display" = "Dataset") %>%
    dplyr::mutate("type" = "ici") %>%
    dplyr::add_row("display" = c("TCGA", "PCAWG"), "type" = "analysis") %>%
    dplyr::mutate("name" = stringr::str_replace_all(.data$display, " ", "_"))

  iatlas.data::synapse_store_feather_file(
    tbl,
    "datasets.feather",
    "syn22165541"
  )
}

