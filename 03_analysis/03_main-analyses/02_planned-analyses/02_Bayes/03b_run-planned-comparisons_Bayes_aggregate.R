# Planned comparisons using Bayesian models aggregated by subjects

# Training ----

# Language Variety ----

message("Running Planned Comparisons Bayes Aggregate Training: Language Variety.")

# make models for fitting
if (experiment == 0) {
  train_l_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) * picture_condition * language_variety +
    picture_condition:language_variety:dialect_words +
    (ot1 + ot2):picture_condition:language_variety:dialect_words +
    participant_number"
  ))
} else if (experiment %in% c(1, 2)) {
  train_l_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    ot1 * picture_condition * task * language_variety +
    picture_condition:task:language_variety:dialect_words +
    ot1:task:picture_condition:language_variety:dialect_words +
    participant_number"
  ))
} else if (experiment == 3) {
  train_l_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) * task * language_variety +
    task:language_variety:dialect_words +
    (ot1 + ot2):task:language_variety:dialect_words +
    participant_number"
  ))
}

train_l_bf_reduced_formula_agg <- update(
  train_l_bf_max_formula_agg,
  ~ .
  - language_variety
)

train_l_bf_keeps_agg <- c(
  "picture_condition",
  "language_variety",
  "dialect_words",
  "ot1",
  "ot2",
  "task",
  "participant_number"
)

# iterations

# fit models and extract model comparison
train_l_bf_agg <- evaluate_model_pair_bf(
  train_l_bf_max_formula_agg,
  train_l_bf_reduced_formula_agg,
  "participant_number",
  train_l_bf_keeps_agg,
  training_data_agg_bf,
  1e4
)

# Word Type by Language Variety and Picture Condition (experiment 0) ----

# make models for fitting
if (experiment == 0) {
  message("Running Planned Comparisons Bayes Aggregate Training: Word Type by Language Variety and Picture Condition.")
  
  train_wlp_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) *
    dialect_words +
    participant_number"
  ))
  
  train_wlp_bf_reduced_formula_agg <- update(
    train_wlp_bf_max_formula_agg,
    ~ .
    - dialect_words
  )
  
  train_wlp_bf_keeps_agg <- c(
    "ot1", 
    "ot2",
    "dialect_words", 
    "participant_number"
  )
  
  train_wlp_pair_bf_agg <- test_pairwise_bf(
    training_data_agg_bf,
    train_wlp_bf_max_formula_agg,
    train_wlp_bf_reduced_formula_agg,
    "participant_number",
    train_wlp_bf_keeps_agg,
    iterations,
    language_variety,
    picture_condition
  )
}

# Word Type by Task, Picture Condition, and Language Variety (experiments 1 and 2) ----

# make models for fitting
if (experiment %in% c(1, 2)) {
  message("Running Planned Comparisons Bayes Aggregate Training: Word Type by Task, Language Variety, and Picture Condition.")
  
  train_wtlp_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    ot1 *
    dialect_words +
    participant_number"
  ))
  
  train_wtlp_bf_reduced_formula_agg <- update(
    train_wtlp_bf_max_formula_agg,
    ~ .
    - dialect_words
  )
  
  train_wtlp_bf_keeps_agg <- c(
    "ot1", 
    "dialect_words", 
    "participant_number"
  )
  
  train_wtlp_pair_bf_agg <- test_pairwise_bf(
    training_data_agg_bf,
    train_wtlp_bf_max_formula_agg,
    train_wtlp_bf_reduced_formula_agg,
    "participant_number",
    train_wtlp_bf_keeps_agg,
    iterations,
    language_variety,
    task,
    picture_condition
  )
}

# Word Type by Task by Language Variety (Experiment 3) ----

if (experiment == 3) {
  message("Running Planned Comparisons Bayes Aggregate Training: Word Type by Task and Language Variety.")
  
  train_wtl_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) *
    dialect_words +
    participant_number"
  ))
  
  train_wtl_bf_reduced_formula_agg <- update(
    train_wtl_bf_max_formula_agg,
    ~ .
    - dialect_words
  )
  
  train_wtl_bf_keeps_agg <- c(
    "ot1", 
    "ot2",
    "dialect_words", 
    "participant_number"
  )
  
  train_wtl_pair_bf_agg <- test_pairwise_bf(
    training_data_agg_bf,
    train_wtl_bf_max_formula_agg,
    train_wtl_bf_reduced_formula_agg,
    "participant_number",
    train_wtl_bf_keeps_agg,
    iterations,
    language_variety,
    task
  )
}

# Testing ----

# Language Variety Main Effect ----

message("Running Planned Comparisons Bayes Aggregate Testing: Language Variety.")

if (experiment == 0) {
  test_l_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    picture_condition *
    language_variety/
    dialect_words +
    participant_number"
  ))
} else if (experiment %in% c(1, 2)) {
  test_l_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~
    task *
    picture_condition *
    language_variety/
    dialect_words +
    participant_number"
  ))
} else if (experiment == 3) {
  test_l_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~
    task *
    language_variety/
    dialect_words +
    participant_number"
  ))  
}

test_l_bf_reduced_formula_agg <- update(
  test_l_bf_max_formula_agg,
  ~ .
  - language_variety
)

test_l_bf_keeps_agg <- c(
  "task",
  "picture_condition", 
  "langauge_variety",
  "dialect_words",
  "participant_number"
)

# fit models and extract model comparison
test_l_bf_agg <- evaluate_model_pair_bf(
  test_l_bf_max_formula_agg,
  test_l_bf_reduced_formula_agg,
  "participant_number",
  test_l_bf_keeps_agg,
  testing_data_agg_bf,
  iterations
)

# Language Variety for Novel Words ----

# make maximal and reduced models

message("Running Planned Comparisons Bayes Aggregate Testing: Language Variety (Novel Words).")
if (experiment == 0) {
  test_l_n_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    picture_condition *
    language_variety +
    participant_number"
  ))  
} else if (experiment %in% c(1, 2)) {
  test_l_n_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    task *
    picture_condition *
    language_variety +
    participant_number"
  ))  
} else if (experiment == 3) {
  test_l_n_bf_max_formula_agg <- as.formula(paste(
    dv_transformed, 
    "~ 
    task *
    language_variety +
    participant_number"
  ))  
}

test_l_n_bf_reduced_formula_agg <- update(
  test_l_n_bf_max_formula_agg,
  ~ .
  - language_variety
)

test_l_n_bf_keeps_agg <- c(
  "picture_condition",
  "task", 
  "language_variety", 
  "participant_number"
)

# fit models and extract model comparison
test_l_n_bf_agg <- evaluate_model_pair_bf(
  test_l_n_bf_max_formula_agg,
  test_l_n_bf_reduced_formula_agg,
  "participant_number",
  test_l_n_bf_keeps_agg,
  testing_data_agg_bf_l_n, # novel words only
  iterations
)

# Word Type by Picture Condition and Language Variety (experiment 0) ----

# same formulae used for Experiments 1 and 2, hence
# this section is not in the if statement.

# make models for fitting
test_wlp_pair_bf_max_formula_agg <- as.formula(paste(
  dv_transformed, 
  "~ 
  dialect_words +
  participant_number"
))

test_wlp_pair_bf_reduced_formula_agg <- update(
  test_wlp_pair_bf_max_formula_agg,
  ~ .
  - dialect_words
)

test_wlp_pair_bf_keeps_agg <- c(
  "dialect_words",
  "participant_number"
)

if (experiment == 0) {
  message("Running Planned Comparisons Bayes Aggregate Testing: Word Type by Picture Condition and Language Variety.")
  # fit and add models to data.frame
  test_wlp_pair_bf_agg <- test_pairwise_bf(
    testing_data_agg_bf_wlp,
    test_wlp_pair_bf_max_formula_agg,
    test_wlp_pair_bf_reduced_formula_agg,
    "participant_number",
    test_wlp_pair_bf_keeps_agg,
    iterations,
    language_variety,
    picture_condition
  )  
}

# Word Type by Task by Picture Condition by Language Variety (experiment 1 and 2) ----

# uses same models and factors as wl (experiment 0) for Ex 1 and 2
# but is updated to remove picture condition for Experiment 3
if (experiment %in% c(1, 2)) {
  message("Running Planned Comparisons Bayes Aggregate Testing: Word Type by Task, Picture Condition, and Language Variety.")
  
  test_wtlp_pair_bf_agg <- test_pairwise_bf(
    testing_data_agg_bf_wtlp,
    test_wlp_pair_bf_max_formula_agg,
    test_wlp_pair_bf_reduced_formula_agg,
    "participant_number",
    test_wlp_pair_bf_keeps_agg,
    iterations,
    task,
    language_variety,
    picture_condition
  )   
}

if (experiment == 3) {
  message("Running Planned Comparisons Bayes Aggregate Testing: Word Type by Task and Language Variety.")
  
  test_wtl_pair_bf_agg <- test_pairwise_bf(
    testing_data_agg_bf_wtl,
    test_wlp_pair_bf_max_formula_agg,
    test_wlp_pair_bf_reduced_formula_agg,
    "participant_number",
    test_wlp_pair_bf_keeps_agg,
    iterations,
    task,
    language_variety
  )
}