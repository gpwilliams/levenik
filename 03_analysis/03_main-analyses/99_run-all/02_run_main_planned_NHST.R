# Run Main and Planned NHST Analyses ----

# Prepares data, fits main and planned NHST models, and saves output.
message("Running main and planned NHST.")

# prepare data
prepare_data(where = data_preparation_source_files, skip = data_prepared)
data_prepared <- TRUE # skip preparation later if still TRUE.

# run and save outputs (and demographics) to a list
source_files(main_planned_NHST_source_files)
main_planned_NHST_run <- TRUE # skip reanalysis later if still TRUE.

# save planned NHST test
saveRDS(
  demographics,
  file = demographics_output_path
)

saveRDS(
  main_models,
  file = main_models_output_path
)

saveRDS(
  planned_comparisons_NHST,
  file = planned_comparisons_NHST_output_path
)