# Run Bayesian Analyses ----

# This comes last due to taking a very long time to run

# Prepares data, fits planned Bayesian models, and saves output.
message("Running planned Bayesian tests.")

# run planned Bayesian analyses, saving outputs to a list
source_files(planned_Bayes_source_files)

# save planned Bayesian tests
saveRDS(planned_comparisons_Bayes, file = planned_Bayes_output_path)