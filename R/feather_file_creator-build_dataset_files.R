build_dataset_table <- function(){
  require(magrittr)

  tbl <- "syn21557455" %>%
    iatlas.data::synapse_feather_id_to_tbl() %>%
    dplyr::select("display" = "Dataset") %>%
    dplyr::add_row("display" = c("TCGA", "PCAWG")) %>%
    dplyr::mutate("name" = stringr::str_replace_all(display, " ", "_"))

  iatlas.data::synapse_store_feather_file(
    tbl,
    "datasets.feather",
    "syn22165541"
  )
}

