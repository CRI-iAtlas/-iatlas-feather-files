synapse_store_feather_file <- function(df, file_name, parent_id){
  arrow::write_feather(df, file_name, compression = "uncompressed")
  synapse_store_file(file_name, parent_id)
  file.remove(file_name)
}

synapse_store_file <- function(file, parent_id) {
  synapser::synLogin()
  file_entity <- synapser::File(file, parent_id)
  synapser::synStore(file_entity)
}

synapse_feather_id_to_tbl <- function(id) {
  synapser::synLogin()
  id %>%
    synapser::synGet() %>%
    purrr::pluck("path") %>%
    arrow::read_feather(.) %>%
    dplyr::as_tibble()
}

synapse_delimited_id_to_tbl <- function(id, delim = "\t") {
  synapser::synLogin()
  id %>%
    synapser::synGet() %>%
    purrr::pluck("path") %>%
    readr::read_delim(., delim = delim)
}

synapse_rds_id_tbl <- function(id) {
  synapser::synLogin()
  id %>%
    synapser::synGet() %>%
    purrr::pluck("path") %>%
    readRDS() %>%
    dplyr::as_tibble()
}

synapse_read_all_feather_files <- function(
  parent_id,
  fileview_id = "syn25202370",
  version = NULL
){
  tbl <-
    create_fileview_tbl(fileview_id, version) %>%
    synapse_read_all_feather_files_in_parent_id(parent_id)
}
create_fileview_tbl <- function(fileview_id = "syn25202370", version = NULL){
  synapser::synLogin()
  if(!is.null(version)) fileview_id <- stringr::str_c(fileview_id, ".", version)
  tbl <- fileview_id %>%
    stringr::str_c("SELECT * FROM ", .) %>%
    synapser::synTableQuery() %>%
    purrr::pluck("filepath") %>%
    readr::read_csv() %>%
    as.data.frame() %>%
    dplyr::as_tibble()
}

synapse_read_all_feather_files_in_parent_id <- function(filevew_tbl, parent_id){
  synapser::synLogin()
  filevew_tbl %>%
    dplyr::filter(.data$parentId == parent_id) %>%
    dplyr::select("entity" = "id", "version" = "currentVersion") %>%
    purrr::pmap(synapser::synGet) %>%
    purrr::map(purrr::pluck("path")) %>%
    purrr::map(arrow::read_feather) %>%
    purrr::discard(., purrr::map_int(., nrow) == 0) %>%
    dplyr::bind_rows()
}



