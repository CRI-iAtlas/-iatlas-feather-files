tcga_build_tags_files <- function() {

  require(magrittr)

  get_tags <- function() {

    all_tags <- "syn22140514" %>%
      iatlas.data::synapse_feather_id_to_tbl()

    tags1 <- all_tags %>%
      dplyr::select(
        "name" = "FeatureValue",
        "characteristics" = "Characteristics",
        "display" = "FeatureName" ,
        "color" = "FeatureHex"
      )

    tags2 <- all_tags %>%
      dplyr::filter(sample_group == "Subtype_Curated_Malta_Noushmehr_et_al") %>%
      dplyr::select(
        "name" = "TCGA Studies",
        "display" = "FeatureDisplayName"
      ) %>%
      dplyr::distinct() %>%
      dplyr::mutate(
        "name" = paste0(name, " Subtypes")
      )

    tags <-
      dplyr::bind_rows(tags1, tags2) %>%
      dplyr::add_row(
        "name" = c("Immune_Subtype", "TCGA_Subtype", "TCGA_Study"),
        "display" = c("Immune Subtype", "TCGA Subtype", "TCGA Study"),
      ) %>%
      dplyr::add_row(
        "name" = c("extracellular_network", "cellimage_network"),
        "display" = c("Extracellular Network", "Cellimage Network")
      ) %>%
      dplyr::add_row(
        "name" = c("parent_group", "metagroup", "group", "network"),
        "display" = c("Parent Group", "Metagroup", "Group", "Network")
      ) %>%
      dplyr::arrange(name)

    return(tags)
  }

  iatlas.data::synapse_store_feather_file(
    get_tags(),
    "tcga_tags.feather",
    "syn22125978"
  )

}
