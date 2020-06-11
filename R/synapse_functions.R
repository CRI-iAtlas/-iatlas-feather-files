attempt_instantiate_synapse <- function() {
  if (reticulate::py_module_available("synapseclient")) {
    synapse <- reticulate::import("synapseclient")
    return(synapse)
  }
  cat(crayon::red("synapseclient unavailable!\n"))
  return(NULL)
}

attempt_instantiate_synapse_table <- function() {
  if (reticulate::py_module_available("synapseclient.table")) {
    syntab <- reticulate::import("synapseclient.table")
    return(syntab)
  }
  cat(crayon::red("synapseclient.table unavailable!\n"))
  return(NULL)
}

create_global_synapse_connection <- function() {
  if (!iatlas.data::present(.GlobalEnv$syn)) {
    syn <- iatlas.data::attempt_instantiate_synapse()
    synapse <- syn$Synapse()
    if (!is.null(synapse) & is.null(synapse$username)) {
      synapse$login()
    } else if (is.null(synapse)) {
      cat(crayon::green("NOT Logged into Synapse\n"))
      return(NA)
    }
    syntab <- attempt_instantiate_synapse_table()
    .GlobalEnv$syn <- syn
    .GlobalEnv$synapse <- synapse
    .GlobalEnv$syntab <- syntab
    cat(crayon::green("Logged into Synapse\n"))
  } else {
    cat(crayon::green("Already logged into Synapse\n"))
  }
  return(.GlobalEnv$synapse)
}

synapse_logout <- function() {
  if (iatlas.data::present(.GlobalEnv$synapse)) {
    .GlobalEnv$synapse$logout()
    rm(synapse, pos = ".GlobalEnv")
  }
  cat(crayon::green("Logged out of Synapse\n"))
  return(NULL)
}

synapse_store_feather_file <- function(df, file_name, parent_id){
  res <- feather::write_feather(df, file_name)
  iatlas.data::synapse_store_file(file_name, parent_id)
  file.remove(file_name)
  return(res)
}

synapse_store_file <- function(file, parent_id) {
  create_global_synapse_connection()
  file_entity <- .GlobalEnv$syn$File(file, parent_id)
  .GlobalEnv$synapse$store(file_entity)
}

synapse_feather_id_to_tbl <- function(id) {
  create_global_synapse_connection()
  id %>%
    .GlobalEnv$synapse$get() %>%
    purrr::pluck("path") %>%
    feather::read_feather(.) %>%
    dplyr::as_tibble()
}

synapse_delimited_id_to_tbl <- function(id, delim = "\t") {
  create_global_synapse_connection()
  id %>%
    .GlobalEnv$synapse$get() %>%
    purrr::pluck("path") %>%
    readr::read_delim(., delim = delim)
}

synapse_rds_id_tbl <- function(id) {
  create_global_synapse_connection()
  id %>%
    .GlobalEnv$synapse$get() %>%
    purrr::pluck("path") %>%
    readRDS() %>%
    dplyr::as_tibble()
}

update_synapse_table <- function(
  table_id,
  tbl,
  syntab  = .GlobalEnv$syntab,
  synapse = .GlobalEnv$synapse
){
  create_global_synapse_connection()
  current_rows <- synapse$tableQuery(glue::glue("SELECT * FROM {table_id}"))
  synapse$delete(current_rows)
  tmpfile <- fs::file_temp("rows.csv")
  readr::write_csv(tbl, tmpfile, na = "")
  update_rows <- syntab$Table(table_id, tmpfile)
  synapse$store(update_rows)
}

