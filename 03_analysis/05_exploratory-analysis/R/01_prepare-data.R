# XXX ----

# get dialect pronunciations, used for indexing responses
# in the main data set
word_list_data <- readr::read_csv(
  here::here(
    "01_materials", 
    "word_list", 
    "input", 
    "spelling_and_pronunciations.csv"
  )
) %>%
  select(contrastive_pronunciation) %>%
  drop_na() %>% 
  pull(contrastive_pronunciation)

# task trial id is the same as trial_id in experiment 0 due to
# having only one task; use this for filtering similarly to other
# experiments (below)
if(experiment == 0) {
  data$task_trial_id <- data$trial_id
}

# filter to only testing data
# subset by orthography to make sure data is split by experiment 
# in the case of experiments 1 and 2
# then extract only incorrect trials
# and generate an ID for dialect pronunciation or not
data_subset <- data %>%
  filter(
    block == "TEST",
    orthography_condition == orthography
  ) %>% 
  arrange(participant_number, task_trial_id) %>% 
  mutate(
    primary_coder_dialect_pronunciation = ifelse(
      primary_coder_response %in% word_list_data, "Dialect Word", "Other"
    ),
    secondary_coder_dialect_pronunciation = ifelse(
      secondary_coder_response %in% word_list_data, "Dialect Word", "Other"
    ),
    lenient_dialect_pronunciation = ifelse(
      primary_coder_response %in% word_list_data | 
        secondary_coder_response %in% word_list_data,
      "Dialect Word", "Other"
    )
  )

# relabel and reorder things for plotting
data_subset <- data_subset %>% 
  mutate(
    task = fct_recode(
      task,
      "Reading" = "R",
      "Spelling" = "W"
      ),
    language_variety = fct_relevel(
      language_variety,
      "standard", 
      "dialect"
    ),
    language_variety = fct_recode(
      language_variety,
      "Variety Match" = "standard",
      "Variety Mismatch" = "dialect"
      ),
    dialect_words = fct_relevel(
      dialect_words,
      "no_shift_word", 
      "shifted_word", 
      "can_shift_word"
    ),
    dialect_words = fct_recode(
      dialect_words,
      "Non-contrastive" = "no_shift_word",
      "Contrastive" = "shifted_word",
      "Untrained" = "can_shift_word"
    )
  )