# Post-hoc comparisons using NHST - Experiment 2

message("Running Post-hoc Comparisons: Experiment 2.")

# Training ----

# Picture Condition ? Task ----

message(
  "Running Post-hoc Comparisons: 
  Experiment 2 -- Training Picture Condition by Task"
)

# pairwise contrasts
train_pt_pair <- emmeans(
  lme_train_treatment_coded, 
  ~ task | picture_condition
)

# Testing ----

# Picture Condition ? Task ----

message(
  "Running Post-hoc Comparisons: 
  Experiment 2 -- Testing Picture Condition by Task"
)

# test for effects in the presence of higher-order interactions
# i.e. Picture Condition ? Task ? Word Novelty
test_pt_reduced_formula <- update(
  test_max_model, 
  ~. - picture_condition_c:task_c
)

# refit training model with ML (instead of REML) for model comparisons
lme_test_ml <- lmer(
  test_max_model, 
  data = testing, 
  REML = FALSE,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

test_pt_reduced <- lmer(
  test_pt_reduced_formula,
  data = testing,
  REML = FALSE,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

test_pt_model_comparison <- anova(lme_test_ml, test_pt_reduced)

# pairwise contrasts

test_pt_pair <- emmeans(
  lme_test_treatment_coded, 
  ~ task | picture_condition
)

# Task ? Language Variety ----

# pairwise tests
test_tl_pair <- emmeans(
  lme_test_treatment_coded, 
  ~ language_variety | task
)

# Task ? Word Novelty ----

message(
  "Running Post-hoc Comparisons: 
  Experiment 2 -- Testing Task by Word Novelty"
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

# pairwise contrasts

# reuses test_n_pair_grid from:
# /02_planned-analyses/02_run_planned_comparisons_NHST.R 

# you must calculate by the new grouping factor first
# before calculating pairwise emms by any other group (or by no (NULL) group)
test_tn_pair <- emmeans(
  test_n_pair_grid, 
  ~ task | test_words
)

# Picture Condition ? Task ? Word Novelty ----

# reuses test_n_pair_grid from:
# /02_planned-analyses/02_run_planned_comparisons_NHST.R 

# you must calculate by the new grouping factor first
# before calculating pairwise emms by any other group (or by no (NULL) group)
test_ptn_pair <- emmeans(
  test_n_pair_grid, 
  ~ picture_condition:task | test_words
)

# Additional Requested Analyses ----

# Picture Condition ? Task ? Word Novelty ----

# already done in post-hoc comparisons above