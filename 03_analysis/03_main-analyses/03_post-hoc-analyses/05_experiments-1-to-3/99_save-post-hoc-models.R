# Save all models created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in run-all-analyses.R.

# post-hoc comparisons ----

# add shared comparisons to existing post-hoc-comparisons
post_hoc_comparisons[["lme_test_task"]] <- lme_test_task