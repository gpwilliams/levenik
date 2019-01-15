# Save Main Models and Data for Planned Comparisons from NHST ----

# These lists are saved in an RData file in the run_analyses.R script.

# demographics ----
demographics <- list(
  demographic_summary = demographic_summary, 
  gender_count = gender_count, 
  english_proficiency = english_proficiency, 
  overall_performance_descriptives = overall_performance_descriptives
)

# main models (lme4) ----
main_models <- list(
  train_max_model = train_max_model,
  lme_train = lme_train,
  test_max_model = test_max_model,
  lme_test = lme_test
)

# planned comparisons ----
planned_comparisons_NHST <- list(
  test_l_n_max_formula = test_l_n_max_formula,
  test_l_n = test_l_n
) 