# Save all models created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in the run-all-analyses.R script.

# post-hoc comparisons ----

post_hoc_comparisons <- list(
  lme_train_ml = lme_train_ml,
  train_tl = train_tl,
  train_tl_model_comparison = train_tl_model_comparison,
  train_tl_pair = train_tl_pair,
  train_wbl_pair = train_wbl_pair,
  test_tw_pair = test_tw_pair,
  test_tn_pair = test_tn_pair
)