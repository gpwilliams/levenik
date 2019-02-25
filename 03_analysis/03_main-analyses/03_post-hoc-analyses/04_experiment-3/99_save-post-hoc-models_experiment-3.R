# Save all models created from the analysis scripts in a series of lists
# This is used for saving to an .RData file later in the run-all-analyses.R script.

# post-hoc comparisons ----

post_hoc_comparisons <- list(
  train_tb_pair = train_tb_pair,
  train_bql_pair = train_bql_pair,
  train_ltb_pair = train_ltb_pair
)