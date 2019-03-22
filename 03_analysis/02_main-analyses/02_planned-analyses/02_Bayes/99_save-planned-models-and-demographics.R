# Save all models/tests created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in run-all-analyses.R.

planned_comparisons_Bayes <- list(
  brm_train = brm_train,
  brm_train_bf = brm_train_bf,
  brm_test = brm_test,
  brm_test_bf = brm_test_bf,
  brm_test_novel = brm_test_novel,
  brm_test_novel_bf = brm_test_novel_bf,
  cores = cores # cores used for fitting
) 