# Post-hoc comparisons using NHST - Experiment 3

message("Running Post-hoc Comparisons: Experiment 3.")

# Training ----

# Block ? Task ----

train_tb_pair <- emmeans(
  lme_train, 
  ~ task | block_num,
  at = list(block_num = unique(training$block_num))
)

# Block (quadratic) ? Language Variety ----

train_bql_pair <- emmeans(
  lme_train, 
  ~ language_variety | block_num,
  at = list(block_num = unique(training$block_num))
)

# Block ? Task ? Language Variety ----

train_ltb_pair <- emmeans(
  lme_train, 
  ~ language_variety | task:block_num,
  at = list(block_num = unique(training$block_num))
)

# Testing ---------------------------------------------------------------------

# NA