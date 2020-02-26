# descriptive statistics ----

# counts for all words ----

data_summaries <- list()

# counts for all words
all_error_by_subj <- data_subset %>% 
  mutate(lenient_dialect_pronunciation = ifelse(lenient_dialect_pronunciation == "Dialect Word", 1, 0)) %>% 
  group_by(participant_number, task, language_variety, dialect_words) %>% 
  summarise(dialect_errors = sum(lenient_dialect_pronunciation), N = length(lenient_dialect_pronunciation))

# get summary of errors by participant
data_summaries$all_error_averages_by_subj <- all_error_by_subj %>% 
  group_by(task, language_variety, dialect_words) %>% 
  summarise(
    total = sum(dialect_errors),
    n_obs = sum(N),
    n_subj = length(dialect_errors),
    total_prop = total/n_obs,
    mean_prop = mean(dialect_errors/N), 
    sd_prop = sd(dialect_errors/N),
    se_prop = sd(dialect_errors/N)/sqrt(length(dialect_errors/N))
  )

# counts for only incorrect words ----

# count numbers per participant
error_by_subj <- data_subset %>% 
  filter(lenient_correct == 0) %>% 
  mutate(lenient_dialect_pronunciation = ifelse(lenient_dialect_pronunciation == "Dialect Word", 1, 0)) %>% 
  group_by(participant_number, task, language_variety, dialect_words) %>% 
  summarise(dialect_errors = sum(lenient_dialect_pronunciation), N = length(lenient_dialect_pronunciation))

# get summary of errors by participant
data_summaries$error_averages_by_subj <- error_by_subj %>% 
  group_by(task, language_variety, dialect_words) %>% 
  summarise(
    total = sum(dialect_errors),
    n_obs = sum(N),
    n_subj = length(dialect_errors),
    total_prop = total/n_obs,
    mean_prop = mean(dialect_errors/N), 
    sd_prop = sd(dialect_errors/N),
    se_prop = sd(dialect_errors/N)/sqrt(length(dialect_errors/N))
  )

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