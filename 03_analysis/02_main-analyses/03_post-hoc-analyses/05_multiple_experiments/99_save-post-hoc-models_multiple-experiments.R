# Save all models created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in the run-all-analyses.R script.

# post-hoc comparisons ----

multiple_experiment_post_hoc_comparisons <- list(
  lme_experiment_novelty = lme_experiment_novelty,
  test_en_pair = test_en_pair
)