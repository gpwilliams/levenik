# descriptive statistics ----

# counts for all words ----

data_summaries <- list()

# counts for all words
all_error_by_subj <- data_subset %>% 
  group_by(
    participant_number, 
    task, 
    language_variety, 
    dialect_words, 
    interacting_factors,
    lenient_coder_error_types
  ) %>% 
  summarise(counts = length(lenient_coder_error_types)) %>% 
  ungroup() %>% 
  group_by(
    participant_number, 
    task, 
    language_variety, 
    dialect_words,
    interacting_factors
  ) %>% 
  mutate(n = sum(counts), prop = counts/n)

# averages
data_summaries$mean_proportions <- all_error_by_subj %>% 
  group_by(
    task, 
    language_variety, 
    dialect_words, 
    interacting_factors,
    lenient_coder_error_types
  ) %>% 
  summarise(
    n_subj = length(counts),
    mean_prop = mean(prop), 
    sd_prop = sd(prop),
    se_prop = sd(prop)/sqrt(n_subj),
    ci = qt(0.975, df = n_subj-1)*sd_prop/sqrt(n_subj)
  )

# grand proportions, looking all subjects and trials
data_summaries$grand_proportions <- data_subset %>% 
  group_by(
    task, 
    language_variety, 
    dialect_words, 
    interacting_factors,
    lenient_coder_error_types
  ) %>% 
  summarise(
    counts = length(lenient_coder_error_types), 
    n_subj = length(unique(participant_number))
  ) %>% 
  ungroup() %>% 
  group_by(
    task, 
    language_variety, 
    dialect_words,
    interacting_factors
  ) %>% 
  mutate(n = sum(counts), proportion = counts/n)

# save results
names(data_summaries) %>%
  map(~ write_csv(
    data_summaries[[.]], 
    here(
      "03_analysis", 
      "05_exploratory-analysis", 
      "output",
      "summaries",
      paste0("experiment_", experiment, "_", ., ".csv"))
  ))