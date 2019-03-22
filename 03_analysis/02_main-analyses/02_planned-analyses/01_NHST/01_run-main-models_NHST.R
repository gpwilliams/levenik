# Main Models for Training and Testing Phases
# Maximal fits for both.

# Training ----

# models calculate polynomials in the formula call
# as using pre-calculated column results in incorrect marginal means
# for related covariates if calculating estimated marginal means from the model

# here we use linear and quadratic polynomials with poly(block_num, 2)
# or just linear with poly(block_num, 1)
# notice that block MUST be numeric (not a factor) to calculate polynomials

# additionally, random effects must be numeric (and centred)
# otherwise suppression of correlations between parameter estimates is wrong
# see: https://rpubs.com/Reinhold/22193
# note that fixed and random effects are identical if we use our centred
# numeric variables as random effects, or if we use sum/deviation coded factors

# to get centred polynomials, we made two variables;
# dialect_words_c and test_words_c which looks at 
# contrastive vs non-contrastive and training vs. testing words respectively
# importantly, this doesn't affect the estimates from fixed/random effects
# so using factors in fixed and numeric in random has no impact on model fit
# (aside from numeric allowing suppression of correlations)
# additionally, calculating polynomials on the fly for random effects
# results in incorrect model fits; hence this is also pre-calculated
# as a numeric variable.

message("Running Main Model: Training.")

# define maximal model:
#   Experiment 0 has 6 blocks and reading only (i.e. no spelling task),
#   hence 1st and 2nd order orthogonal polynomials of time (ot) are used.
#   Experiments 1 and 2 have 3 blocks, hence only 1st order polynomial (ot1)
#   Experiment 3 has 6 blocks but no picture condition.

if (experiment == 0) {
  # model fails to converge with full random effects structure
  # attempting a refit with zero correlation on items
  train_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    poly(block_num, 2) * picture_condition * language_variety +
    picture_condition:language_variety:dialect_words +
    poly(block_num, 2):picture_condition:language_variety:dialect_words +
    (language_variety_c * picture_condition_c || target) +
    ((ot1 + ot2) * dialect_words_c | participant_number)"
  ))
} else if (experiment == 1) {
  # model fails to converge with zero correlation on items and subjects
  # using zero-correlation structure throughout
  train_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    poly(block_num, 1) * task * picture_condition * language_variety/dialect_words +
    task * picture_condition * language_variety/dialect_words +
    (task_c * language_variety_c * picture_condition_c || target) +
    (ot1 * task_c * dialect_words_c || participant_number)"
  ))
} else if (experiment == 2) {
  # model fails to converge with full random effects structure
  # attempting a refit with zero correlation on items
  train_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    poly(block_num, 1) * task * picture_condition * language_variety/dialect_words +
    task * picture_condition * language_variety/dialect_words +
    (task_c * language_variety_c * picture_condition_c || target) +
    (ot1 * task_c * dialect_words_c | participant_number)"
  ))
} else if (experiment == 3) {
  # model fails to converge with full random effects structure
  # attempting a refit with zero correlation on items
  train_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    poly(block_num, 2) * task * language_variety +
    task:language_variety:dialect_words +
    poly(block_num, 2):task:language_variety:dialect_words +
    (language_variety_c * task_c || target) +
    ((ot1 + ot2) * task_c * dialect_words_c | participant_number)"
  ))
}

lme_train <- lmer(
  train_max_model, 
  data = training,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

# Testing ----

message("Running Main Model: Testing")

# Experiment 0 has only 1 task.
# Experiment 3 has no picture condition (always picture).
if (experiment == 0) {
  # fits perfectly with full random effects structure
  test_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    picture_condition * language_variety/dialect_words +
    (1 + picture_condition_c * language_variety_c | target) +
    (1 + (dialect_words_c + test_words_c) | participant_number)"
  ))
} else if (experiment == 1) {
  # fits perfectly with full random effects structure
  test_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    task * picture_condition * language_variety/dialect_words +
    (1 + language_variety_c * picture_condition_c * task_c | target) +
    (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
  ))
} else if (experiment == 2) {
  # fails to converge with full, and with zero corr items
  test_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    task * picture_condition * language_variety/dialect_words +
    (1 + language_variety_c * picture_condition_c * task_c || target) +
    (1 + task_c * (dialect_words_c + test_words_c) || participant_number)"
  ))
} else if (experiment == 3) {
  # experiment 3 fits perfectly with full random effects structure
  test_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    task * language_variety/dialect_words +
    (1 + language_variety_c * task_c | target) +
    (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
  ))
}

lme_test <- lmer(
  test_max_model, 
  data = testing,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)