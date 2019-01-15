# Data Preparation for Aggregated Bayesian Analyses ----

# Aggregate by subjects due to problems of fitting with random effects.

# Define factors by which to aggregate.
aggregated_factors_training <- c(
  "participant_number",
  "task",
  "picture_condition",
  "block",
  "language_variety",
  "dialect_words"
)

aggregated_factors_testing <- c(
  "participant_number",
  "task",
  "picture_condition",
  "language_variety",
  "dialect_words",
  "test_words"
)

# remove picture condition from ex3
if (experiment == 3) {
  aggregated_factors_training <- 
    aggregated_factors_training[-3] 
  aggregated_factors_testing <- 
    aggregated_factors_testing[-3]
}

# Training ----

# aggregate
training_data_agg_bf <- training %>%
  group_by_at(aggregated_factors_training) %>%
  summarise(mean_nLED = mean(!!sym(dv))) %>%
  ungroup() %>%
  centre_many(., training_list) %>%
  make_asinsqrt(., agg_dv) %>%
  mutate(block_num = as.numeric(block))

# make orthogonal polynomial time term for training
# linear and quadratic for experiment 0 (6 blocks), linear otherwise (3 blocks)
if (experiment %in% c(0, 3)) {
  polynomials <- poly(1:max(training_data_agg_bf$block_num), 2)
  training_data_agg_bf[, paste0("ot", 1:2)] <- 
    polynomials[training_data_agg_bf$block_num, 1:2]
} else if (experiment %in% c(1, 2)) {
  polynomials <- poly(1:max(training_data_agg_bf$block_num), 1)
  training_data_agg_bf$ot1 <- polynomials[training_data_agg_bf$block_num, 1]
}

# Testing ----

# aggregate
# used also for word type tests (factors used in Bayes so no centring needed)
testing_data_agg_bf <- testing %>%
  group_by_at(aggregated_factors_testing) %>%
  summarise(mean_nLED = mean(!!sym(dv))) %>%
  ungroup() %>%
  centre_many(., testing_list) %>%
  make_asinsqrt(., agg_dv)

# Language Variety for Novel Words ----
testing_data_agg_bf_l_n <- testing_data_agg_bf %>%
  filter(test_words == "testing_word") %>%
  mutate(dialect_words = factor(dialect_words)) # reset levels

# Word Type by Language Variety and Picture Condition (Experiment 0) ----

# recentre var (otherwise incorrectly specified for subgroup analysis)
if (experiment == 0) {
  testing_data_agg_bf_wlp <-
    testing_data_agg_bf %>% 
    filter(test_words != "testing_word") %>% 
    mutate(
      dialect_words = factor(dialect_words),
      dialect_words_c = centre_var(., "dialect_words", "shifted_word")
    ) %>%
    select(-test_words_c)
}

# Word Type by Task, Picture Condition, and Language Variety (Experiments 1 & 2) ----

# recentre var (otherwise incorrectly specified for subgroup analysis)
if (experiment %in% c(1, 2)) {
  testing_data_agg_bf_wtlp <-
    testing_data_agg_bf %>% 
    filter(test_words != "testing_word") %>% 
    mutate(
      dialect_words = factor(dialect_words),
      dialect_words_c = centre_var(., "dialect_words", "shifted_word")
    ) %>%
    select(-test_words_c)
}

# Word Type by Task and Language Variety (Experiment 3) ----

# recentre var (otherwise incorrectly specified for subgroup analysis)
if (experiment == 3) {
  testing_data_agg_bf_wtl <-
    testing_data_agg_bf %>% 
    filter(test_words != "testing_word") %>% 
    mutate(
      dialect_words = factor(dialect_words),
      dialect_words_c = centre_var(., "dialect_words", "shifted_word")
    ) %>%
    select(-test_words_c)
}