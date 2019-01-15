# Run Bayesian Analyses ----

# This comes last due to taking a very long time to run

# Prepares data, fits planned Bayesian models, and saves output.
message("Running planned Bayesian tests.")

# prepare data if not already prepared
prepare_data(where = data_preparation_source_files, skip = data_prepared)
data_prepared <- TRUE # skip preparation later if still TRUE.

# run planned Bayesian analyses, saving outputs to a list
source_files(planned_Bayes_source_files)

# save planned Bayesian tests
saveRDS(planned_comparisons_Bayes, file = planned_Bayes_output_path)
saveRDS(planned_comparisons_Bayes_agg, file = planned_Bayes_agg_output_path)