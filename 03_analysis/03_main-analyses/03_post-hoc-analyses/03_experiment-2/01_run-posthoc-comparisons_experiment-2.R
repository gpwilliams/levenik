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
  lme_train, 
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
  lme_test, 
  ~ task | picture_condition
)