# Run Demographics ----

# Prepares data and saves demographic output.
message("Preparing data.")

# run and save demographics to a list
source_files(data_preparation_source_files)

# save demographics
saveRDS(
  demographics,
  file = demographics_output_path
)