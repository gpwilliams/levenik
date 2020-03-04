# load all libraries
libraries <- c("here", "tidyverse")
lapply(libraries, library, character.only = TRUE)

source(here(
  "03_analysis", 
  "02_main-analyses", 
  "99_run-all", 
  "01b_data_paths.R"
))

# extract demographic data
experiments <- 0:3 
english_proficiencies <- list()
all_language_counts <- list()
known_language_category <- list()

for(i in seq_along(experiments)) {
  experiment <- experiments[i]
  # load data
  if (experiment == 0) {
    load(ex_zero_data)
  } else if (experiment %in% c(1, 2)) {
    load(ex_one_two_data)
  } else {
    load(ex_three_data)
  }
  
  if(experiment == 1) {
    demo_data <- demo_data %>% filter(orthography_condition == "transparent")
  } else if (experiment == 2) {
    demo_data <- demo_data %>% filter(orthography_condition == "opaque")
  }
  
  # make demographic summary; count numbers reporting range on Likert
  # 1 being poor English, 5 being native-like English
  english_proficiencies[[i]] <- demo_data %>% 
    filter(language_spoken == "English") %>% 
    mutate(language_proficiency_rating = factor(
      language_proficiency_rating, levels = 1:5
    )) %>% 
    group_by(language_proficiency_rating, .drop = FALSE) %>% 
    count() %>% 
    mutate(experiment = experiment)
  
  # see distribution of languages spoken across all participants
  all_language_counts[[i]] <- demo_data %>% 
    group_by(language_spoken) %>% 
    summarise(n = n()) %>% 
    mutate(experiment = experiment)
  
  # check whether participants are monolingual or multilingual
  known_language_category[[i]] <- demo_data %>% 
    group_by(participant_number) %>% 
    summarise(n = length(language_spoken)) %>% 
    mutate(speaker_category = case_when(
      n == 1 ~ "monolingual",
      n > 1 ~ "multilingual"
    )) %>% 
    group_by(speaker_category) %>% 
    summarise(n = n()) %>% 
    mutate(experiment = experiment)
}

# bind the data together
english_proficiencies <- bind_rows(english_proficiencies) %>% 
  select(experiment, everything())

all_language_counts <- bind_rows(all_language_counts) %>% 
  select(experiment, everything())

known_language_category <- bind_rows(known_language_category) %>% 
  select(experiment, everything())

# save as a csv
write_csv(english_proficiencies, here(
  "03_analysis", 
  "04_demographic_checks", 
  "english_proficiency_counts.csv"
))

write_csv(all_language_counts, here(
  "03_analysis", 
  "04_demographic_checks", 
  "all_language_counts.csv"
))

write_csv(known_language_category, here(
  "03_analysis", 
  "04_demographic_checks", 
  "known_language_category.csv"
))