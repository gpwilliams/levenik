# Save all models created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in run-all-analyses.R.

# planned comparisons Bayes Factors (by subjects/item random effects) ----

# all models include all fixed and random effects
planned_comparisons_Bayes <- list(
  train_l_bf = train_l_bf,
  test_l_bf = test_l_bf,
  test_l_n_bf = test_l_n_bf,
  iterations = iterations # iterations used in fitting models
) 

if (experiment == 0) {
  planned_comparisons_Bayes[["train_wlp_pair_bf"]] <- 
    train_wlp_pair_bf
  planned_comparisons_Bayes[["test_wlp_pair_bf"]] <- 
    test_wlp_pair_bf
}

if (experiment %in% c(1, 2)) {
  planned_comparisons_Bayes[["train_wtlp_pair_bf"]] <- 
    train_wtlp_pair_bf
  planned_comparisons_Bayes[["test_wtlp_pair_bf"]] <- 
    test_wtlp_pair_bf
}

if (experiment == 3) {
  planned_comparisons_Bayes[["train_wtl_pair_bf"]] <- 
    train_wtl_pair_bf
  planned_comparisons_Bayes[["test_wtl_pair_bf"]] <- 
    test_wtl_pair_bf
}

# planned comparisons Bayes Factors (aggregated by subjects) ----

planned_comparisons_Bayes_agg <- list(
  train_l_bf_agg = train_l_bf_agg,
  test_l_bf_agg = test_l_bf_agg,
  test_l_n_bf_agg = test_l_n_bf_agg,
  iterations = iterations # iterations used in fitting models
)  

if (experiment == 0) {
  planned_comparisons_Bayes_agg[["train_wlp_pair_bf_agg"]] <- 
    train_wlp_pair_bf_agg
  planned_comparisons_Bayes_agg[["test_wlp_pair_bf_agg"]] <- 
    test_wlp_pair_bf_agg
}

if (experiment %in% c(1, 2)) {
  planned_comparisons_Bayes_agg[["train_wtlp_pair_bf_agg"]] <- 
    train_wtlp_pair_bf_agg
  planned_comparisons_Bayes_agg[["test_wtlp_pair_bf_agg"]] <- 
    test_wtlp_pair_bf_agg
}

if (experiment == 3) {
  planned_comparisons_Bayes_agg[["train_wtl_pair_bf_agg"]] <- 
    train_wtl_pair_bf_agg
  planned_comparisons_Bayes_agg[["test_wtl_pair_bf_agg"]] <- 
    test_wtl_pair_bf_agg
}