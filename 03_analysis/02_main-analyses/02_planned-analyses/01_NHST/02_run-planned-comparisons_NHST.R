# Planned comparisons using NHST

# Testing ----

# Language Variety for Novel Words ----

message(
"Running Planned Comparisons NHST: Testing Language Variety for Novel Words."
)

if (experiment == 0) {
  # model reduced to prevent perfect correlations 
  # between by-item random effects.
  test_l_n_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    picture_condition * language_variety +
    (1 + picture_condition_c * language_variety_c || target) +
    (1 | participant_number)"
  ))
} else if (experiment == 1) {
  test_l_n_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    task * picture_condition * language_variety +
    (1 + language_variety_c * picture_condition_c * task_c | target) +
    (1 + task_c | participant_number)"
  ))
} else if (experiment == 2) {
  # model reduced to prevent perfect correlation between
  # intercept and language_variety_c by item and
  # picture_condition_c:task_c and language_variety_c:task_c by item
  test_l_n_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    task * picture_condition * language_variety +
    (1 + 
    picture_condition_c + 
    task_c + 
    language_variety_c:picture_condition_c + 
    language_variety_c:task_c + 
    language_variety_c:picture_condition_c:task_c | target) +
    (0 + language_variety_c + picture_condition_c:task_c | target) +
    (1 + task_c | participant_number)"
  ))
} else if (experiment == 3) {
  test_l_n_max_formula <- as.formula(paste(
    dv_transformed,
    "~ 
    task * language_variety +
    (1 + language_variety_c * task_c | target) +
    (1 + task_c  | participant_number)"
  )) 
}

test_l_n <- lmer(
  test_l_n_max_formula,
  data = testing %>% filter(test_words == "testing_word"),
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)