# Data Preparation ----

# Demographics and Overall Performance ----

# Calculates descriptive statistics for demographics and overall performance
# by participants in the study.

# participant demographics
demo <- demo_data %>%
  filter(orthography_condition %in% orthography) %>%
  spread(language_spoken, language_proficiency_rating) 

# summary of demographics
demographic_summary <- demo %>% 
  summarise(
    n = length(unique(participant_number)), 
    age_mean = mean(age), 
    age_sd = sd(age),
    age_min = min(age),
    age_max = max(age),
    time_mean = lubridate::as.duration(mean(total_time)),
    time_sd = lubridate::as.duration(sd(total_time))
  )

gender_count <- demo %>%
  group_by(gender) %>%
  count()

english_proficiency <- demo %>% 
  summarise(mean = mean(English), SD = sd(English))

# overall performance
overall_performance_descriptives <- data %>%
  summarise_by_orthography(., orthography)