# Post-hoc comparisons using NHST - Experiment 3

message("Running Post-hoc Comparisons: Experiment 3.")

# Training ----

# Block × Task ----

train_tb_pair <- emmeans(
  lme_train_treatment_coded, 
  ~ task | block_num,
  at = list(block_num = unique(training$block_num))
)

# Task × Language Variety ----

message(
  "Running Post-hoc Comparisons: 
  Experiment 3 -- Training Task by Language Variety"
)

# check for effect in presence of higher-order interactions
train_tl_reduced_formula <- update(
  train_max_model,
  ~.
  - task_c:language_variety_c
)

# refit training model with ML (instead of REML) for model comparisons

# fails to converge with this full formula
# this cannot be adjusted as it's based on the main model
# therefore ignore this anova comparison between models
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

# pairwise tests
train_tl_pair <- emmeans(
  lme_train_treatment_coded, 
  ~ language_variety | task
)

# Block × Task × Language Variety ----

train_ltb_pair <- emmeans(
  lme_train_treatment_coded, 
  ~ language_variety | task:block_num,
  at = list(block_num = unique(training$block_num))
)

# Testing ---------------------------------------------------------------------

# Task × Language Variety ----

message(
  "Running Post-hoc Comparisons: 
  Experiment 3 -- Testing Task by Language Variety"
)

# check for main effect in presence of higher-order interactions
test_tl_reduced_formula <- update(
  test_max_model,
  ~.
  - task_c:language_variety_c
)

# refit training model with ML (instead of REML) for model comparisons
lme_test_ml <- lmer(
  test_max_model, 
  data = testing, 
  REML = FALSE,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

# Fails to converge with the full formula.
# Since we cannot adjust the main formula to accommodate this model
# it's best to ignore this in analyses.
test_tl <- lmer(
  test_tl_reduced_formula, 
  data = testing,
  REML = FALSE,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

test_tl_model_comparison <- anova(lme_test_ml, test_tl)

# pairwise tests
test_tl_pair <- emmeans(
  lme_test_treatment_coded, 
  ~ language_variety | task
)

# Task × Word Type ----

test_wt_pair <- emmeans(
  lme_test_treatment_coded, 
  ~ dialect_words | task
)

# Task × Word Novelty ----

message(
  "Running Post-hoc Comparisons: 
  Experiment 3 -- Testing Task by Word Novelty"
)

# test for effects in the presence of higher-order interactions
# i.e. Picture Condition ? Task ? Word Novelty
test_tn_reduced_formula <- update(
  test_max_model, 
  ~. - task_c:test_words_c
)

# There is a perfect correlation between task_c:picture_condition_c and 
# task by items. The only way to fix this is to reduce the main model,
# which we need to keep maximal. Thus, interpretation of this model
# should be made with caution as we cannot remedy the perfect correlation
# between random effects.
test_tn_reduced <- lmer(
  test_tn_reduced_formula,
  data = testing,
  REML = FALSE,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

# reuses lme_test_lm from earlier model comparison
test_tn_model_comparison <- anova(lme_test_ml, test_tn_reduced)

# pairwise comparisons

# reuses test_n_pair_grid from:
# /02_planned-analyses/02_run_planned_comparisons_NHST.R 

# marginal effect
# task: word novelty
test_tn_pair <- emmeans(
  test_n_pair_grid, 
  ~ task | test_words
)

# Additional Requested Analyses ----

# Additional Analyses for comparison to Experiment 0 ----

# Language Variety for Novel Words in the Reading Task ----

# pairwise tests

# reuses test_n_pair_grid from planned comparisons

# for some reason the EMMs are off for by = language_variety
# so you must calculate by the new grouping factor first
# before calculating pairwise emms by any other group (or by no (NULL) group)
test_ntl_pair <- emmeans(
  test_n_pair_grid, 
  ~ task:language_variety | test_words
)

# already done in post-hoc comparisons above