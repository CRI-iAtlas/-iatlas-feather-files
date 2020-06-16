# require(magrittr)
# library(dplyr)
#
# all_features <- "syn21540314" %>%
#   iatlas.data::synapse_feather_id_to_tbl()
#
# new_features <- all_features %>%
#   dplyr::filter(!present_TCGA, VariableType == "Numeric") %>%
#   dplyr::select(
#     "name" = "FeatureMatrixLabelTSV",
#     "display" = "FriendlyLabel",
#     "class" = "Variable Class",
#     "order" = "Variable Class Order",
#     "unit" = "Unit"
#   )
#
# .GlobalEnv$syn$build_table("new_features", "syn21069182", new_features) %>%
#   .GlobalEnv$synapse$store()
#
# feature_values <- "syn21540315" %>%
#   iatlas.data::synapse_feather_id_to_tbl() %>%
#   dplyr::mutate(
#     "Drug" = dplyr::case_when(
#       is.na(Drug) & Antibody == "aCTLA4" ~ "anti_aCTLA4",
#       is.na(Drug) & Antibody == "aPD1" ~ "anti_aPD1",
#       is.na(Drug) & Antibody == "aPD1 + aCTLA4" ~ "anti_aPD1 + anti_aCTLA4",
#       T ~ Drug
#     ),
#     "Patient_ID" = dplyr::if_else(
#       is.na(Patient_ID),
#       Sample_ID,
#       Patient_ID
#     )
#   ) %>%
#   dplyr::select(
#     "sample" = "Sample_ID",
#     "patient" = "Patient_ID",
#     "treatment" = "Drug",
#     "time_of_collection" = "treatment_when_collected",
#     "antibody" = "Antibody",
#     dplyr::everything()
#   )
#
# feature_names <- all_features %>%
#   dplyr::filter(VariableType == "Numeric") %>%
#   dplyr::pull("FeatureMatrixLabelTSV")
#
# # tags ----
#
# groups <- "syn22005988" %>%
#   synapse_delimited_id_to_tbl(delim = ",")
#
#
#
# # features_to_samples ----
#
#
#
# features_to_samples <- feature_values %>%
#   dplyr::select(dplyr::all_of(c("sample", feature_names))) %>%
#   tidyr::pivot_longer(-"sample") %>%
#   tidyr::drop_na() %>%
#   dplyr::mutate("name" = stringr::str_replace_all(name, "\\.", "_"))
#
# .GlobalEnv$syn$build_table("features_to_samples", "syn21069182", features_to_samples) %>%
#   .GlobalEnv$synapse$store()
#
# # features
#
# treatments <- feature_values %>%
#   dplyr::select("treatment", "antibody") %>%
#   dplyr::distinct() %>%
#   dplyr::add_row("treatment" = c(
#     "BRAF",
#     "platinum",
#     "MAPKi"
#   )) %>%
#   dplyr::filter(!stringr::str_detect(treatment, "\\+"))
#
# .GlobalEnv$syn$build_table("treatments", "syn21069182", treatments) %>%
#   .GlobalEnv$synapse$store()
#
# # treatments_to_samples ----
#
# treatments_to_samples1 <- feature_values %>%
#   dplyr::select("sample", "time_of_collection", "treatment") %>%
#   dplyr::filter(time_of_collection %in% c("Post", "Mid")) %>%
#   tidyr::separate_rows("treatment", sep = " \\+ ") %>%
#   dplyr::mutate("is_main_io_treatment" = T)
#
# treatments_to_samples2 <- feature_values %>%
#   dplyr::filter(pre_BRAF) %>%
#   dplyr::select("sample") %>%
#   dplyr::mutate(
#     "treatment" = "BRAF",
#     "time_of_collection" = "Post",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_samples3 <- feature_values %>%
#   dplyr::filter(CTLA4_Pretreatment) %>%
#   dplyr::select("sample") %>%
#   dplyr::mutate(
#     "treatment" = "Ipilimumab",
#     "time_of_collection" = "Post",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_samples4 <- feature_values %>%
#   dplyr::filter(Received_platinum) %>%
#   dplyr::select("sample") %>%
#   dplyr::mutate(
#     "treatment" = "platinum",
#     "time_of_collection" = "Post",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_samples5 <- feature_values %>%
#   dplyr::filter(Previous_MAPKi) %>%
#   dplyr::select("sample") %>%
#   dplyr::mutate(
#     "treatment" = "MAPKi",
#     "time_of_collection" = "Post",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_samples6 <- feature_values %>%
#   dplyr::filter(Neoadjuvant == "Neoadjuvant") %>%
#   dplyr::select("sample") %>%
#   dplyr::mutate(
#     "treatment" = "Pembrolizumab",
#     "time_of_collection" = "Post",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_samples <-
#   dplyr::bind_rows(
#     treatments_to_samples1,
#     treatments_to_samples2,
#     treatments_to_samples3,
#     treatments_to_samples4,
#     treatments_to_samples5,
#     treatments_to_samples6
#   ) %>%
#   dplyr::arrange("sample", "treatment")
#
# .GlobalEnv$syn$build_table("treatments_to_samples", "syn21069182", treatments_to_samples) %>%
#   .GlobalEnv$synapse$store()
#
# # treatments_to_patients ----
#
# treatments_to_patients1 <- feature_values %>%
#   dplyr::select("patient", "treatment") %>%
#   tidyr::separate_rows("treatment", sep = " \\+ ") %>%
#   dplyr::mutate("is_main_io_treatment" = T)
#
# treatments_to_patients2 <- feature_values %>%
#   dplyr::filter(pre_BRAF | post_BRAF) %>%
#   dplyr::select("patient", "pre_BRAF", "post_BRAF") %>%
#   tidyr::pivot_longer(-"patient") %>%
#   dplyr::filter(value) %>%
#   tidyr::separate(name, into = c("time_of_treatment", "treatment"), sep = "_") %>%
#   dplyr::select(-"value") %>%
#   dplyr::mutate(
#     "is_main_io_treatment" = F,
#     "time_of_treatment" = stringr::str_to_title(time_of_treatment)
#   )
#
# treatments_to_patients3 <- feature_values %>%
#   dplyr::filter(CTLA4_Pretreatment) %>%
#   dplyr::select("patient") %>%
#   dplyr::mutate(
#     "treatment" = "Ipilimumab",
#     "time_of_treatment" = "Pre",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_patients4 <- feature_values %>%
#   dplyr::filter(Received_platinum) %>%
#   dplyr::select("patient") %>%
#   dplyr::mutate(
#     "treatment" = "platinum",
#     "time_of_treatment" = "Pre",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_patients5 <- feature_values %>%
#   dplyr::filter(Previous_MAPKi) %>%
#   dplyr::select("patient") %>%
#   dplyr::mutate(
#     "treatment" = "MAPKi",
#     "time_of_treatment" = "Pre",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_patients6 <- feature_values %>%
#   dplyr::filter(Neoadjuvant == "Neoadjuvant") %>%
#   dplyr::select("patient") %>%
#   dplyr::mutate(
#     "treatment" = "Pembrolizumab",
#     "time_of_treatment" = "Pre",
#     "is_main_io_treatment" = F
#   )
#
# treatments_to_patients <-
#   dplyr::bind_rows(
#     treatments_to_patients1,
#     treatments_to_patients2,
#     treatments_to_patients3,
#     treatments_to_patients4,
#     treatments_to_patients5,
#     treatments_to_patients6
#   ) %>%
#   dplyr::arrange("patient", "treatment") %>%
#   dplyr::distinct()
#
# .GlobalEnv$syn$build_table("treatments_to_patients", "syn21069182", treatments_to_patients) %>%
#   .GlobalEnv$synapse$store()
