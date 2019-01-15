# Post-hoc comparisons using NHST - Experiment 0

message("Running Post-hoc Comparisons: Experiment 0.")

# Training ----

# Language Variety ? Word Type ----

# already in planned comparisons

# Block (linear) ? Picture Condition ? Language Variety ----

train_bpl_pair <- emmeans(
  lme_train_treatment_coded, ~ picture_condition | block_num:language_variety,
  at = list(block_num = unique(training$block_num))
)

# Testing ----

# Picture Condition ? Word Novelty ----

# reuses test_n_pair_grid from:
# /02_planned-analyses/02_run_planned_comparisons_NHST.R 

# you must calculate by the new grouping factor first
# before calculating pairwise emms by any other group (or by no (NULL) group)
test_pn_pair <- emmeans(
  test_n_pair_grid, ~ picture_condition | test_words
)

# Language Variety ? Word Type ----

# already in planned comparisons

# Additional Requested Analyses ----

# Picture Condition ? Word Novelty ----

# already done in post-hoc comparisons above.