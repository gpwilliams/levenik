# Specifies Models used for Bayesian analyses
# These match the NHST models closely, with the exception of an
# additional model (Novel Words Only during Testing), which is
# only tested using Bayesian models.

# Training ----

# uses (ot1 + ot2) instead of poly(block_num, 2) as in lme4
# simply due to efficiency of fitting with pre-calculated numeric
# variables instead of ordered factors
if (experiment == 0) {
  train_max_model_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    (ot1 + ot2) * picture_condition * language_variety +
    picture_condition:language_variety:dialect_words +
    (ot1 + ot2):picture_condition:language_variety:dialect_words +
    (language_variety_c * picture_condition_c | target) +
    ((ot1 + ot2) * dialect_words_c | participant_number)"
  ))
} else if (experiment %in% c(1, 2)) {
  # maximal model works with both experiments
  train_max_model_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    ot1 * task * picture_condition * language_variety/dialect_words +
    task * picture_condition * language_variety/dialect_words +
    (task_c * language_variety_c * picture_condition_c | target) +
    (ot1 * task_c * dialect_words_c | participant_number)"
  ))
} else if (experiment == 3) {
  train_max_model_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    (ot1 + ot2) * task * language_variety +
    task:language_variety:dialect_words +
    (ot1 + ot2):task:language_variety:dialect_words +
    (language_variety_c * task_c | target) +
    ((ot1 + ot2) * task_c * dialect_words_c | participant_number)"
  ))
}

# Testing ----

# Main Model ----

if (experiment == 0) {
  test_max_model_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    picture_condition*language_variety/dialect_words +
    (1 + picture_condition_c * language_variety_c | target) +
    (1 + (dialect_words_c + test_words_c) | participant_number)"
  ))
} else if (experiment %in% c(1, 2)) {
  test_max_model_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    task*picture_condition*language_variety/dialect_words +
    (1 + language_variety_c * picture_condition_c * task_c | target) +
    (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
  ))
} else if (experiment == 3) {
  test_max_model_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    task*language_variety/dialect_words +
    (1 + language_variety_c * task_c | target) +
    (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
  ))
}

# Novel Words Only ----

# Note: data is only for novel words, so the dialect_words factor is not needed
# and the dialect_words_c + test_words_c random effects are not needed.
# Thus we use a different model to the Main Model.

if (experiment == 0) {
  test_max_model_novel_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    picture_condition*language_variety +
    (1 + picture_condition_c * language_variety_c | target) +
    (1 | participant_number)"
  ))
} else if (experiment %in% c(1, 2)) {
  test_max_model_novel_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    task*picture_condition*language_variety +
    (1 + language_variety_c * picture_condition_c * task_c | target) +
    (1 + task_c  | participant_number)"
  ))
} else if (experiment == 3) {
  test_max_model_novel_brms <- as.formula(paste(
    dv_transformed_scaled,
    "~ 
    task*language_variety +
    (1 + language_variety_c * task_c | target) +
    (1 + task_c | participant_number)"
  ))
}