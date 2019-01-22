# Prepate Data for Post-Hoc comparisons using NHST - Experiments 1, 2, and 3

# Used for comparing models directly to Experiment 0.
# Here we recentre variables by their subgroups to account for any imbalances
# in coding across and within conditions.

# Testing ----

# Main Model Split by Task ----

# define centring lists
if (experiment %in% c(1, 2)) {
  # define variables to centre
  testing_task_list <- list(
    factors = c(
      "picture_condition",
      "language_variety",
      "test_words",
      "dialect_words"
    ),
    levels = c(
      "picture",
      "standard",
      "testing_word",
      "shifted_word"
    )
  )
} else if (experiment == 3) {
  # define variables to centre
  testing_task_list <- list(
    factors = c(
      "language_variety",
      "test_words",
      "dialect_words"
    ),
    levels = c(
      "standard",
      "testing_word",
      "shifted_word"
    )
  )
}

if (experiment > 0) {
  # centre all variables; 
  # set testing words (can_shift_word) to 0 to ignore this
  # level for the dialect_words factor (but tested by the test_words factor)
  testing_task <- testing %>%
    mutate(
      dialect_words = replace(
        dialect_words,
        dialect_words == "can_shift_word",
        NA
      )
    ) %>%
    centre_many(., testing_task_list, by_group = TRUE, task) %>%
    replace_na(list(dialect_words_c = 0, dialect_words = "can_shift_word"))
} else {
  # Do nothing.
  # No post-hoc analyses based on additional research questions
  # planned for Experiment 0.
}