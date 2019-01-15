# Data Preparation for Bayesian Analyses ----

# Planned comparisons ----

# Testing ----

# Note: when factors are mutated to themselves as a factor, this
#   drops unused levels from the factor. This is necessary after subsetting

# Language Variety for Novel Words ----
testing_l_n_data <- testing %>% 
  filter(test_words == "testing_word") %>%
  mutate(dialect_words = factor(dialect_words))

# Word Type by Picture Condition and Language Variety ----

if (experiment == 0) {
  testing_wlp_data <- testing %>% 
    filter(test_words != "testing_word") %>%
    mutate(dialect_words = factor(dialect_words)) # reset levels
}

# Word Type by Task, Picture Condition, and Language Variety ----

if (experiment %in% c(1, 2)) {
  testing_wtlp_data <- testing %>% 
    filter(test_words != "testing_word") %>%
    mutate(dialect_words = factor(dialect_words)) # reset levels
}

if (experiment == 3) {
  testing_wtl_data <- testing %>% 
    filter(test_words != "testing_word") %>%
    mutate(dialect_words = factor(dialect_words)) # reset levels
}