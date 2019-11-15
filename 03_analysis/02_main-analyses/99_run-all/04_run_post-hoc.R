# Run Post-Hoc Comparisons ----

# Prepares data, fits post-hoc comparisons, and saves output.
message("Running post-hoc tests.")

# Notes -----

# Post-hoc comparisons rely on making reduced models from the 
# main model formulae, and running anova() on the main and reduced models.
# To do so, check for these items in the session. 
# If not, see if we have them saved. Failing that, rerun prior to post-hocs.

# prepare data if not already done so

if (main_planned_NHST_run == TRUE) {
  # if NHST was run in this session do nothing
  # as the critical files are already accessible for conducting post-hocs
  message(
    "Main and planned comparisons have been run in this session.",
    "\n Skipping straight to post-hoc analyses based on main and planned models."
    )
} else if (
    file.exists(main_models_output_path) &
    file.exists(planned_comparisons_NHST_output_path)
  ) {
  message(
    "Main and planned comparisons have not run in this session.",
    "\n Loading previous models from saved files in the output folder."
  )
  # if not run in this session, try loading the critical files
  # for conducting post-hocs if they have been saved
  main_models <- readRDS(file = main_models_output_path)
  
  planned_comparisons_NHST <- readRDS(
    file = planned_comparisons_NHST_output_path
  )
  
  # access main models and model formulae from list
  train_max_model <- main_models$train_max_model
  lme_train <- main_models$lme_train
  test_max_model <- main_models$test_max_model
  lme_test <- main_models$lme_test
  
} else {
  # if all else fails, rerun and save main and planned comparisons
  message(
    paste(
      "Main and planned comparisons have not run in this session.",
      "\n These files are also not saved in the outputs folder.",
      "\n Running main and planned models first",
      "\n as they are necessary for post-hocs."
    )
  )
  source(tests_main_planned_NHST_path)
}

# run post-hoc comparisons
source_files(post_hoc_source_files)

# save post-hocs
saveRDS(post_hoc_comparisons, file = post_hoc_output_path)