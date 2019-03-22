# Data Preparation for NHST & Bayesian Analyses ----

# Centre Variables ----

# establish list of variables to be centred (and which level to be positive)
training_list <-
  list(
    factors = c(
      "task",
      "picture_condition",
      "language_variety",
      "dialect_words"
    ),
    levels = c(
      "R",
      "picture",
      "standard",
      "shifted_word"
    )
  )

testing_list <- list(
  factors = c(
    "task",
    "picture_condition",
    "language_variety",
    "dialect_words",
    "test_words"
  ),
  levels = c(
    "R",
    "picture",
    "standard",
    "can_shift_word",
    "testing_word"
  )
)

# remove task if experiment is experiment 0 (only reading task)
if (experiment == 0) {
  # removing 1st elements (no task in ex0); order matters
  training_list <- map(training_list, function(x) x[-1]) 
  testing_list <- map(testing_list, function(x) x[-1])
} else if (experiment == 3) {
  # removing 2nd elements (no picture conditions in ex3); order matters
  training_list <- map(training_list, function(x) x[-2]) 
  testing_list <- map(testing_list, function(x) x[-2])
}

# centre levels
training <- centre_many(training, training_list)
testing <- centre_many(testing, testing_list)

# set can_shift_words (testing words) to NA so that dialect_words
# ignores the testing words. Then centre all variables
# and reset can_shift_words to 0 (so it is included, but ignored from models)
# comparing effects of dialect_words
# dialect words centered (2 mutate calls to enforce order of execution)
testing <- testing %>%
  # helmert coded centering
  mutate(
    dialect_words = replace(
      dialect_words,
      dialect_words == "can_shift_word",
      NA
      )) %>%
  mutate(dialect_words_c = centre_var(., "dialect_words", "shifted_word")) %>%
  replace_na(list(dialect_words_c = 0, dialect_words = "can_shift_word"))

if(run_three_expt_posthoc == TRUE) {
  # sum coded centering
  testing <- testing %>%
    mutate(experiment = replace(experiment, experiment == "ex1", NA)) %>%
    mutate(experiment_c_02 = centre_var(., "experiment", "ex0")) %>%
    replace_na(list(experiment_c_02 = 0, experiment = "ex1"))
  
  testing <- testing %>%
    mutate(experiment = replace(experiment, experiment == "ex0", NA)) %>%
    mutate(experiment_c_12 = centre_var(., "experiment", "ex1")) %>%
    replace_na(list(experiment_c_12 = 0, experiment = "ex0"))
}