# Post-hoc comparisons using NHST - Experiment 0

message("Running Post-hoc Comparisons: Experiment 0.")

# Training ----

# Block (linear) ? Picture Condition ? Language Variety ----

train_bpl_pair <- emmeans(
  lme_train, ~ picture_condition | block_num:language_variety,
  at = list(block_num = unique(training$block_num))
)

# Testing ----

# NA