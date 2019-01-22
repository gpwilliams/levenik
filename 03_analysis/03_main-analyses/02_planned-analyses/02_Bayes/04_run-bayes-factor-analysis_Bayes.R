# Define Bayes Factor Hypotheses and run Bayes Factor analyses

# This extracts all fixed effects parameters from the fitted model,
# then cleans up the list (removing the appended b_ and excluding the prior)
# before setting all hypotheses to a 
# point null hypothesis (i.e. parameter of interest = 0)
# After this, 

# Training ----

brm_training_hypotheses <- brm_train %>%
  parnames() %>% 
  str_subset("b_") %>%
  str_subset("prior", negate = TRUE) %>%
  str_remove("b_") %>%
  paste0(., " = 0")

brm_train_bf <- hypothesis(brm_train, brm_training_hypotheses)

# Testing ----

# Main Model ----

brm_testing_hypotheses <- brm_test %>%
  parnames() %>% 
  str_subset("b_") %>%
  str_subset("prior", negate = TRUE) %>%
  str_remove("b_") %>%
  paste0(., " = 0")

brm_test_bf <- hypothesis(brm_test, brm_testing_hypotheses)

# Novel Words Only ----

brm_testing_novel_hypotheses <- brm_test_novel %>%
  parnames() %>% 
  str_subset("b_") %>%
  str_subset("prior", negate = TRUE) %>%
  str_remove("b_") %>%
  paste0(., " = 0")

brm_test_novel_bf <- hypothesis(brm_test_novel, brm_testing_novel_hypotheses)