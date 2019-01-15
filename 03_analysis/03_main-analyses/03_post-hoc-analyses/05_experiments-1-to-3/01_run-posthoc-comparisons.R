# Post-hoc comparisons using NHST - Experiments 1, 2, & 3
# Used for comparing models directly to Experiment 0

message("Running Post-hoc Comparisons: Experiments 1, 2, and 3.")

# Testing ----

# Main Model split by Task ----

message(
  "Running Post-hoc Comparisons: 
  Experiments 1, 2, and 3 -- Testing Main Model by Task"
)

# define formula
if (experiment == 1) {
  # fit maximal model
  test_task_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    picture_condition_c * 
    language_variety_c *
    (dialect_words_c + test_words_c) +
    (picture_condition_c * language_variety_c | target) +
    ((dialect_words_c + test_words_c) | participant_number)"
  ))
} else if (experiment == 2) {
  # maximal model has perfect correlations on item random effects
  # thus, fit a reduced model. The maximal model to converge
  # with factors of interest in random effects and without perfect
  # correlations between terms is one with no correlation between
  # random effects by items (target)
  test_task_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    picture_condition_c * 
    language_variety_c *
    (dialect_words_c + test_words_c) +
    (picture_condition_c * language_variety_c || target) +
    ((dialect_words_c + test_words_c) | participant_number)"
  ))
} else if (experiment == 3) {
  # maximal model has perfect correlations on item random effects
  # thus, fit a reduced model. The maximal model to converge
  # with factors of interest in random effects and without perfect
  # correlations between terms is one with no correlation between
  # random effects by items (target)
  test_task_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    language_variety_c *
    (dialect_words_c + test_words_c) +
    (language_variety_c || target) +
    ((dialect_words_c + test_words_c) | participant_number)"
  ))
}

# fit model by task
lme_test_task <- lme_by(
  testing_task,
  test_task_max_model,
  drop_term = FALSE,
  task
)

# Language Variety for Novel Words in the Reading Task ----

# Already in planned comparisons (Word Type by Task and Language Variety)