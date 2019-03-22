# cross coding ----

# subset and order data
# reading task only, with responses coded by either person

# task trial id is the same as trial_id in experiment 0 due to
# having only one task; use this for filtering similarly to other
# experiments (below)
if(experiment == 0) {
  data$task_trial_id <- data$trial_id
}

# make sure data is split by experiment in the case of experiments 1 and 2
data <- data %>% filter(orthography_condition == orthography)

data_subset <- data %>%
  filter(
    task == "R" &
    !is.na(primary_coder_response) |
    !is.na(secondary_coder_response)
  ) %>%
  select(
    participant_number,
    task_trial_id,
    target,
    primary_coder_response: secondary_coder_nLED
  ) %>%
  arrange(participant_number, task_trial_id)