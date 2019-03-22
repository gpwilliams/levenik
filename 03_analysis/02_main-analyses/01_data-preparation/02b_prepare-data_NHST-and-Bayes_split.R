# Data Preparation for NHST & Bayesian Analyses ----

# Split data into training and testing, keep only required orthography
# make scaled DV for use in Bayesian models (easier to set priors this way)
# remove datetimes (stops coercion warnings when fitting models)

training <- data %>%
  filter(orthography_condition %in% orthography & block != "TEST") %>%
  mutate(
    orthography_condition = factor(orthography_condition),
    asin_scaled = as.numeric(scale(asin))
  ) %>%
  select(-c(submission_time, running_time))

testing <- data %>%
  filter(orthography_condition %in% orthography & block == "TEST") %>%
  mutate(
    orthography_condition = factor(orthography_condition),
    asin_scaled = as.numeric(scale(asin))
  ) %>%
  select(-c(submission_time, running_time))

# reset levels to remove dropped levels for block/dialect words
training <- training %>% mutate_at(c("dialect_words", "block"), factor)
testing <- testing %>% mutate(block = factor(block))