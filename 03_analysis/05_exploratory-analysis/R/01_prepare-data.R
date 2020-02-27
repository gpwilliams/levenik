# Prepare Data for Error Explorations ----

# Complex analysis with a join. Lookup table needs dialect spelling, 
# dialect spelling again(but with primary or secondary input label) and a target word column. 
# Joining will give you two new columns, dialect spelling and correct target spelling. 
# See if target and target and dialect with transcription match in table. If so, give 1. If not, give 0.

# get dialect pronunciations, used for indexing responses
# in the main data set
word_list_data <- readr::read_csv(
  here::here(
    "01_materials", 
    "word_list", 
    "input", 
    "spelling_and_pronunciations.csv"
  )
)

word_list_spelling <- word_list_data %>% 
  select(
    dialect_contrastive_response = contrastive_pronunciation, 
    target = `non-contrastive_pronunciation`) %>% 
  mutate(task = "R")

word_list_reading <- word_list_data %>% 
  select(target = contains(orthography)) %>% 
  mutate(task = "W")

keydict <- full_join(
  word_list_spelling, 
  word_list_reading, 
  by = c("target", "task")
  ) %>% 
  mutate(key_target = target)

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

# logic:
# if the key target matches the actual target
# AND if the item was incorrect
# AND if the dialect contrastive pronunciation matches the primary coder response
# then give it the label "dialect word incorrect",
# otherwise assign to other label

data_subset <- data %>%
  drop_na(lenient_nLED) %>% 
  filter(
    block == "TEST",
    orthography_condition == orthography
  ) %>% 
  arrange(participant_number, task_trial_id) %>%
  left_join(., keydict, by = c("task", "target")) %>% 
  mutate(
    primary_coder_error_types = case_when(
      key_target == target & 
        primary_coder_correct == 0 & 
        dialect_contrastive_response == primary_coder_response ~ 
        "dialect_word_match",
        primary_coder_correct == 0 & 
        primary_coder_response %in% unique(na.omit(dialect_contrastive_response))  ~ 
        "dialect_word_mismatch",
      key_target == target &
        primary_coder_correct == 0 &
        primary_coder_response %in% unique(target) ~ 
        "standard_word_mismatch",
      key_target == target & 
        primary_coder_correct == 0 ~ 
        "other_mismatch",
      primary_coder_correct == 1 ~ "correct"
    ),
    secondary_coder_error_types = case_when(
      key_target == target & 
        secondary_coder_correct == 0 & 
        dialect_contrastive_response == secondary_coder_response ~ 
        "dialect_word_match",
      secondary_coder_correct == 0 & 
        secondary_coder_response %in% unique(na.omit(dialect_contrastive_response))  ~ 
        "dialect_word_mismatch",
      key_target == target &
        secondary_coder_correct == 0 &
        secondary_coder_response %in% unique(target) ~ 
        "standard_word_mismatch",
      key_target == target & 
        secondary_coder_correct == 0 ~ 
        "other_mismatch",
      secondary_coder_correct == 1 ~ "correct"
    ),
    lenient_coder_error_types = case_when(
      primary_coder_error_types == "correct" | secondary_coder_error_types == "correct" ~ "correct",
      primary_coder_error_types == "dialect_word_match" | secondary_coder_error_types == "dialect_word_match" ~ "dialect_word_match",
      primary_coder_error_types == "dialect_word_mismatch" | secondary_coder_error_types == "dialect_word_mismatch" ~ "dialect_word_mismatch",
      primary_coder_error_types == "standard_word_mismatch" | secondary_coder_error_types == "standard_word_mismatch" ~ "standard_word_mismatch",
      primary_coder_error_types == "other_mismatch" | secondary_coder_error_types == "other_mismatch" ~ "other_mismatch",
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
    ),
    lenient_coder_error_types = fct_relevel(
      lenient_coder_error_types,
      "correct", 
      "dialect_word_match", 
      "dialect_word_mismatch",
      "standard_word_mismatch", 
      "other_mismatch"
    ),
    lenient_coder_error_types = fct_recode(
      lenient_coder_error_types,
      "Correct" = "correct", 
      "Dialect Word Match" = "dialect_word_match", 
      "Dialect Word Mismatch" = "dialect_word_mismatch",
      "Standard Word Mismatch" = "standard_word_mismatch", 
      "Other Mismatch" = "other_mismatch"
    )
  )