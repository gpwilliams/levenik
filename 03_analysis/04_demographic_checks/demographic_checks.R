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
proficiencies <- list()

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
  proficiencies[[i]] <- demo_data %>% 
    filter(language_spoken == "English") %>% 
    mutate(language_proficiency_rating = factor(
      language_proficiency_rating, levels = 1:5
    )) %>% 
    group_by(language_proficiency_rating, .drop = FALSE) %>% 
    count() %>% 
    mutate(experiment = experiment)
}

# bind the data together
proficiencies <- bind_rows(proficiencies) %>% 
  select(experiment, everything())

# save as a csv
write_csv(proficiencies, here(
  "03_analysis", 
  "04_demographic_checks", 
  "english_proficiency_counts.csv"
))