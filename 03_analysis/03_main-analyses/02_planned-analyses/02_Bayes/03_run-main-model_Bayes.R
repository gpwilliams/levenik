# Runs Bayesian model fitting and hypothesis testing
# used priors, model formulae, and hypotheses defined in previous scripts

# define cores for parallel processing
cores <- parallel::detectCores() # 6 on my machine

# Training ----

message("Running Planned Comparisons Bayes: Training.")

# fit main model
brm_train <- brm(
  train_max_model_brms, 
  data = training, 
  prior = training_priors,
  sample_prior = TRUE,
  iter = 2000, 
  cores = cores,
  control = list(max_treedepth = 10) # set at default of 10
)

# Testing ----

message("Running Planned Comparisons Bayes: Testing.")

# fit main model
brm_test <- brm(
  test_max_model_brms, 
  data = testing, 
  prior = testing_priors,
  sample_prior = TRUE,
  iter = 2000, 
  cores = cores,
  control = list(max_treedepth = 10) # default of 10
)

# Novel Words Only ----

# Uses same priors as main model

message("Running Planned Comparisons Bayes: Testing (Novel Words Only).")

# fit model
brm_test_novel <- brm(
  test_max_model_novel_brms, 
  data = testing %>% filter(test_words == "testing_word"), 
  prior = testing_priors,
  sample_prior = TRUE,
  iter = 2000, 
  cores = cores,
  control = list(max_treedepth = 10) # default of 10
)