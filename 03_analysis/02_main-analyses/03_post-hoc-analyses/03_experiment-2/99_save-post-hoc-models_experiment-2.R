# Save all models created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in the run-all-analyses.R script.

# post-hoc comparisons ----

post_hoc_comparisons <- list(
  train_pt_pair = train_pt_pair,
  lme_test_ml = lme_test_ml,
  test_pt_reduced = test_pt_reduced,
  test_pt_model_comparison = test_pt_model_comparison,
  test_pt_pair = test_pt_pair
)