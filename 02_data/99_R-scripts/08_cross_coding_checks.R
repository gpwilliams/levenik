###############################################################################
# Cross Coding
###############################################################################

# generates data frames for cross coded items

# outputs CSVs:
#   (a) identifying which participants have been coded, including item counts
#         for both coders
#   (b) identifying which participants and items must be coded by each coder
#   (c) identifying which participants must be coded by each coder 
#         (used for a simpler check in the early stages of coding)

###############################################################################
# Load and subset data
###############################################################################

# Load data
###########

load(paste0(
  "../",
  folder,
  "/03_cleaned-data/",
  experiments,
  "_filtered.Rdata"
))

# drop the writing task (redundant for read only)
coded_data <- subset(data, (task == "R"))

###############################################################################
# Cross-coding manipulations
###############################################################################

# find people and items left to code by both/either coders
primary_coder_to_code <- coded_data %>%
  filter(is.na(primary_coder_nLED)) %>%
  mutate(coder = "Glenn")

secondary_coder_to_code <- coded_data %>%
  filter(is.na(secondary_coder_nLED)) %>%
  mutate(coder = "Vera")


# task_trial_id to session_trial_id for ex0
if(experiments == "ex_0") {
  to_code <- rbind(primary_coder_to_code, secondary_coder_to_code) %>%
    select(coder, participant_number, session_trial_id)
} else {
  to_code <- rbind(primary_coder_to_code, secondary_coder_to_code) %>%
    select(coder, participant_number, task_trial_id)
}

# simpler output of just IDs (i.e. not split by trial, too)
to_code_ids <- to_code %>%
  select(coder, participant_number) %>%
  distinct()

# determine multiple coded participants
#######################################

# summarise: participants and items coded by each coder
if(experiments == "ex_0") {
  participant_coder_ID <- coded_data %>% 
    group_by(participant_number, orthography_condition) %>%
    summarise(
      primary_coded = sum(!is.na(primary_coder_nLED)),
      secondary_coded = sum(!is.na(secondary_coder_nLED)),
      N_trials = length(session_trial_id)
    )
} else {
  participant_coder_ID <- coded_data %>% 
    group_by(participant_number, orthography_condition) %>%
    summarise(
      primary_coded = sum(!is.na(primary_coder_nLED)),
      secondary_coded = sum(!is.na(secondary_coder_nLED)),
      N_trials = length(task_trial_id)
    )
}

# extract number of items coded for participants with multiple coders
multiple_coded <- participant_coder_ID %>% 
  subset(primary_coded != 0 & secondary_coded != 0)

# do the same for completed trials only
completed_multiple_coded <- participant_coder_ID %>% 
  subset(primary_coded == N_trials & secondary_coded == N_trials)

###############################################################################
# Saving outputs
###############################################################################

# save all coding information (used to determine any left during coding)
write.csv(
  participant_coder_ID, 
  paste0("../", 
         folder, 
         "/05_data-checks/",
         experiments,
         "_participant_coder_ID_check.csv"
  )
)

write.csv(
  to_code_ids, 
  paste0("../", 
         folder, 
         "/05_data-checks/",
         experiments,
         "_subjects_to_code.csv"
  )
)

write.csv(
  to_code, 
  paste0("../", 
         folder, 
         "/05_data-checks/",
         experiments,
         "_subjects_and_items_to_code.csv"
  )
)