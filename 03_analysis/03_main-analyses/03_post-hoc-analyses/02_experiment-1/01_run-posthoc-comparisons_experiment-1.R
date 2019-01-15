# Post-hoc comparisons using NHST - Experiment 1

message("Running Post-hoc Comparisons: Experiment 1.")

# Training ----

# Task ? Language Variety ----

message(
"Running Post-hoc Comparisons: Experiment 1 -- Task by Language Variety"
)

# check for effect in presence of higher-order interactions
train_tl_reduced_formula <- update(
  train_max_model,
  ~.
  - task_c:language_variety_c
)

# refit training model with ML (instead of REML) for model comparisons
lme_train_ml <- lmer(
  train_max_model, 
  data = training, 
  REML = FALSE,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

train_tl <- lmer(
  train_tl_reduced_formula, 
  data = training, 
  REML = FALSE,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
  )

train_tl_model_comparison <- anova(lme_train_ml, train_tl)

# test pairwise
train_tl_pair <- emmeans(
  lme_train_treatment_coded, 
  ~ language_variety | task
)

# Block (Linear) ? Language Variety ? Word Type ----

train_wbl_pair <- emmeans(
  lme_train_treatment_coded, 
  ~ dialect_words | block_num:language_variety,
  at = list(block_num = unique(training$block_num))
)

# Task ? Language Variety ? Word Type ----

# already done in planned comparisons

# Testing ----

# Task ? Word Type ----

test_tw_pair <- emmeans(
  lme_test_treatment_coded, 
  ~ dialect_words | task
)

# Task ? Word Novelty ----

# reuses test_n_pair_grid from:
# /02_planned-analyses/02_run_planned_comparisons_NHST.R 

# you must calculate by the new grouping factor first
# before calculating pairwise emms by any other group (or by no (NULL) group)

test_tn_pair <- emmeans(
  test_n_pair_grid, 
  ~ task | test_words
)