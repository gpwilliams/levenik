# Data Preparation for NHST & Bayesian Analyses ----

# Establishes contrasts for analysis

# Set Contrasts ----

# sum and helmert code appropriate factors

# set contrasts for training
contrasts(training$language_variety) <- contr.sum(2)
contrasts(training$dialect_words) <- contr.sum(2)

if(experiment %in% c(0, 1, 2)) {
  contrasts(training$picture_condition) <- contr.sum(2)
}

if(experiment > 0) {
  contrasts(training$task) <- contr.sum(2)
}

# set contrasts for testing

# order levels prior to helmert coding for correct comparisons
testing$dialect_words <- factor(
  testing$dialect_words, 
  levels = c(
    "shifted_word", "no_shift_word", "can_shift_word"
  )
)

contrasts(testing$language_variety) <- contr.sum(2)
contrasts(testing$dialect_words) <- contr.helmert(3)

if(experiment %in% c(0, 1, 2)) {
  contrasts(testing$picture_condition) <- contr.sum(2)
}

if(experiment > 0) {
  contrasts(testing$task) <- contr.sum(2)
}

# set contrasts for 3 experiment post-hoc ----

if(run_three_expt_posthoc == TRUE) {
  testing$experiment <- as.factor(testing$experiment)
  contrasts(testing$experiment) <- contr.sum(3)
  contrasts(testing$test_words) <- contr.sum(2)
}