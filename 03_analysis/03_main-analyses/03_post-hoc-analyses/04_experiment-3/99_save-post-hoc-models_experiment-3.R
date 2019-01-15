# Save all models created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in the run-all-analyses.R script.

# post-hoc comparisons ----

post_hoc_comparisons <- list(
  train_tb_pair = train_tb_pair,
  lme_train_ml = lme_train_ml,
  train_tl = train_tl,
  train_tl_model_comparison = train_tl_model_comparison,
  train_tl_pair = train_tl_pair,
  train_ltb_pair = train_ltb_pair,
  lme_test_ml = lme_test_ml,
  test_tl = test_tl,
  test_tl_model_comparison = test_tl_model_comparison,
  test_tl_pair = test_tl_pair,
  test_wt_pair = test_wt_pair,
  test_tn_reduced = test_tn_reduced,
  test_tn_model_comparison = test_tn_model_comparison,
  test_tn_pair = test_tn_pair,
  test_ntl_pair = test_ntl_pair
)