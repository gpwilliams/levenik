# Full planned comparisons using Bayesian models.
#
# This includes all fixed factors observed,
# with random effects of subjects and items

# Training ----

# Language Variety ----

# make models for fitting
message("Running Planned Comparisons Bayes Training: Language Variety.")

if (experiment == 0) {
  train_l_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) * picture_condition * language_variety +
    picture_condition:language_variety:dialect_words +
    (ot1 + ot2):picture_condition:language_variety:dialect_words +
    participant_number +
    target"
  ))
} else if (experiment %in% c(1, 2)) {
  train_l_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    ot1 * picture_condition * task * language_variety +
    picture_condition:task:language_variety:dialect_words +
    ot1:task:picture_condition:language_variety:dialect_words +
    participant_number +
    target"
  ))
}  else if (experiment == 3) {
  train_l_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) * task * language_variety +
    task:language_variety:dialect_words +
    (ot1 + ot2):task:language_variety:dialect_words +
    participant_number +
    target"
  ))
}

# create reduced formula
train_l_bf_reduced_formula <- update(
  train_l_bf_max_formula,
  ~.
  - language_variety
)

# establish factors to always retain in models
train_l_bf_never_exclude <- c(
  "ot1",
  "ot2",
  "picture_condition",
  "task",
  "language_variety",
  "dialect_words",
  "participant_number",
  "target"
)

# fit models and extract model comparison
train_l_bf <- evaluate_model_pair_bf(
  train_l_bf_max_formula,
  train_l_bf_reduced_formula,
  random_factors_bf,
  train_l_bf_never_exclude,
  training,
  iterations
)

# Word Type by Language Variety and Picture Condition (experiment 0) ----

# make models for fitting
if (experiment == 0) {
  message("Running Planned Comparisons Bayes Training: Word Type by Language Variety and Picture Condition.")
  
  train_wlp_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) *
    dialect_words +
    participant_number + 
    target"
    )
  )
  
  train_wlp_bf_reduced_formula <- update(
    train_wlp_bf_max_formula,
    ~.
    - dialect_words
  )
  
  # establish factors to always retain in models
  train_wlp_bf_never_exclude <- c(
    "ot1",
    "ot2",
    "dialect_words",
    "participant_number",
    "target"
  )
  
  # fit and add models to data.frame
  train_wlp_pair_bf <- test_pairwise_bf(
    training,
    train_wlp_bf_max_formula,
    train_wlp_bf_reduced_formula,
    random_factors_bf,
    train_wlp_bf_never_exclude,
    iterations,
    language_variety,
    picture_condition
  )
} 

# Word Type by Picture Condition, Task, and Language Variety (experiments 1 and 2) ----
if (experiment %in% c(1, 2)) {
  message("Running Planned Comparisons Bayes Training: Word Type by Task, Language Variety, and Picture Condition.")
  train_wtlp_bf_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    ot1 *
    dialect_words +
    participant_number +
    target"
  ))
  
  train_wtlp_bf_reduced_formula <- update(
    train_wtlp_bf_max_formula,
    ~.
    - dialect_words
  )
  
  # establish factors to always retain in models
  train_wtlp_bf_never_exclude <- c(
    "ot1",
    "dialect_words",
    "participant_number",
    "target"
  )
  
  # fit and add models to data.frame
  train_wtlp_pair_bf <- test_pairwise_bf(
    training,
    train_wtlp_bf_max_formula,
    train_wtlp_bf_reduced_formula,
    random_factors_bf,
    train_wtlp_bf_never_exclude,
    iterations,
    task,
    language_variety,
    picture_condition
  ) 
}

# Word Type by Task and Language Variety (experiment 3) ----

# establish maximal models
if (experiment == 3) {
  message("Running Planned Comparisons Bayes Training: Word Type by Task and Language Variety.")
  train_wtl_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    (ot1 + ot2) *
    dialect_words +
    participant_number +
    target"
    ))
  
  train_wtl_bf_reduced_formula <- update(
    train_wtl_bf_max_formula,
    ~.
    - dialect_words
  )
  
  # establish factors to always retain in models
  train_wtl_bf_never_exclude <- c(
    "ot1",
    "ot2",
    "dialect_words",
    "participant_number",
    "target"
  )
  
  # fit and add models to data.frame
  train_wtl_pair_bf <- test_pairwise_bf(
    training,
    train_wtl_bf_max_formula,
    train_wtl_bf_reduced_formula,
    random_factors_bf,
    train_wtl_bf_never_exclude,
    iterations,
    task,
    language_variety
  )   
}

# Testing ----

# Language Variety Main Effect ----

message("Running Planned Comparisons Bayes: Testing Language Variety.")
# make models for fitting
# note: dialect_words is a 3 level factor here, incorporating
#       whether words are contrastive, non-contrastive, or novel
#       thus we do not have test_words as a factor here.
if (experiment == 0) {
  test_l_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    picture_condition *
    language_variety/
    dialect_words +
    participant_number + 
    target"
  ))
} else if (experiment %in% c(1, 2)) {
  test_l_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    task *
    picture_condition *
    language_variety/
    dialect_words +
    participant_number + 
    target"
  ))
} else if (experiment == 3) {
  test_l_bf_max_formula <- as.formula(paste(
    dv_transformed, 
    "~ 
    task *
    language_variety/
    dialect_words +
    participant_number + 
    target"
  ))
}

test_l_bf_reduced_formula <- update(
  test_l_bf_max_formula,
  ~.
  - language_variety
)

# establish factors to always retain in models
test_l_bf_never_exclude <- c(
  "task",
  "picture_condition", 
  "language_variety",
  "dialect_words",
  "participant_number",
  "target"
)

# fit models and extract model comparison
test_l_bf <- evaluate_model_pair_bf(
  test_l_bf_max_formula,
  test_l_bf_reduced_formula,
  random_factors_bf,
  test_l_bf_never_exclude,
  testing,
  iterations
)

# Language Variety for Novel Words ----

# Note: data is only for novel words, so the dialect_words factor is not needed

message("Running Planned Comparisons Bayes Testing: Language Variety (Novel Words).")
if (experiment == 0) {
  test_l_n_bf_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    language_variety *
    picture_condition +
    participant_number +
    target"
  ))
} else if (experiment %in% c(1, 2)) {
  test_l_n_bf_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    task *
    picture_condition *
    language_variety +
    participant_number +
    target"
  ))
} else if (experiment == 3){
  test_l_n_bf_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    task *
    language_variety +
    participant_number +
    target"
  ))  
}

test_l_n_bf_reduced_formula <- update(
  test_l_n_bf_max_formula,
  ~.
  - language_variety
)

# reuse factors never to exclude from Langauge Variety Main Effect
test_l_n_bf <- evaluate_model_pair_bf(
  test_l_n_bf_max_formula,
  test_l_n_bf_reduced_formula,
  random_factors_bf,
  test_l_bf_never_exclude, # reuses factors to not exclude
  testing_l_n_data, # only novel words
  iterations
)

# Word Type by Picture Condition and Language Variety (Experiment 0) ----

# same formulae used in all analyses, hence this section is not in an if statement
test_wlp_bf_max_formula <- as.formula(paste(
  dv_transformed, 
  "~ 
    dialect_words +
    participant_number +
    target"
))

test_wlp_bf_reduced_formula <- update(
  test_wlp_bf_max_formula,
  ~.
  - dialect_words
)

# establish factors to always retain in models
test_wlp_bf_never_exclude <- c(
  "dialect_words",
  "participant_number",
  "target"
)

if (experiment == 0) {
  message("Running Planned Comparisons Bayes Testing: Word Type by Picture Condition and Language Variety.")
  
  # fit and add models to data.frame
  test_wlp_pair_bf <- test_pairwise_bf(
    testing_wlp_data,
    test_wlp_bf_max_formula,
    test_wlp_bf_reduced_formula,
    random_factors_bf,
    test_wlp_bf_never_exclude,
    iterations,
    language_variety,
    picture_condition
  )
}

# Word Type by Task, Picture Condition, and Language Variety (Experiments 1 and 2) ----

# fit and add models to data.frame
if (experiment %in% c(1, 2)) {
  message("Running Planned Comparisons Bayes Testing: Word Type by Task, Picture Condition, and Language Variety.")
  
  test_wtlp_pair_bf <- test_pairwise_bf(
    testing_wtlp_data,
    test_wlp_bf_max_formula,
    test_wlp_bf_reduced_formula,
    random_factors_bf,
    test_wlp_bf_never_exclude,
    iterations,
    task,
    language_variety,
    picture_condition
  ) 
}

# Word Type by Task and Language Variety (Experiment 3) ----

# reuse model details from above

if (experiment == 3) {
  message("Running Planned Comparisons Bayes Testing: Word Type by Task and Language Variety.")
  test_wtl_pair_bf <- test_pairwise_bf(
    testing_wtl_data,
    test_wlp_bf_max_formula,
    test_wlp_bf_reduced_formula,
    random_factors_bf,
    test_wlp_bf_never_exclude,
    iterations,
    task,
    language_variety
  ) 
}