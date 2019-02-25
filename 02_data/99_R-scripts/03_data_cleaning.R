###############################################################################
# Data Cleaning
###############################################################################
# cleans data by resetting values that should be NA
# also cleans up coding for missing/uninterpretable utterances;
# ? = uniterpretable (nLED = 1/correct = 0), * or "" = no submission (NA))
###############################################################################

# Load data
############

load(paste0(
  "../",
  folder,
  "/02_merged-data/",
  experiments,
  "_",
  "refactored.Rdata"
))

# drop any duplicated self-reported languages
demo_data <- demo_data %>%
  distinct(participant_number, language_spoken, .keep_all = TRUE)

###############################################################################
# overall data checking
###############################################################################

# check NA responses have NA values
# make codes consistent; any combination of * or "" is an NA
#   any combination of ? is unsure (nLED 1/correct 0)
# note blank = no input, ? = unknown or unclear input (in speaking)
# a blank can happen if no input was provided during speaking coding
# however it's most likely an NA which has associated NAs for nLEDs
# by default the edit distance is 0 on the server
# this arises most often if the audio file is missing from the server
####################################################################

# check NA responses are NA scores for both coders
check_na_primary <- data %>%
  filter(is.na(primary_coder_response)) %>%
  select(participant_number, primary_coder_nLED, primary_coder_correct)

if (!any(is.na(
  check_na_primary$primary_coder_nLED |
  check_na_primary$primary_coder_correct
  ))) {
  print("NA responses do not have NA scores")
}

check_na_secondary <- data %>%
  filter(is.na(secondary_coder_response)) %>%
  select(participant_number, secondary_coder_nLED, secondary_coder_correct)

if (!any(is.na(
  check_na_secondary$secondary_coder_nLED |
  check_na_secondary$secondary_coder_correct
  ))) {
  print("NA responses do not have NA scores")
}

###############################################################################
# duplicated items
###############################################################################

# identify duplicates
####################

# get original items and their duplicates
original_and_duplicates <- data %>%
  group_by(
    participant_number,
    block, 
    task
  ) %>%
  filter(
    duplicated(word_id, fromLast = TRUE) | # searches left and right
    duplicated(word_id, fromLast = FALSE)
  )

# get only duplicate items from participants in each block and task
duplicates <- data %>%
  group_by(participant_number, block, task) %>%
  filter(duplicated(word_id))

# returns a count of unique items and how often they occur in
# each subject, block, and task
duplicates_by_subjects <- original_and_duplicates %>%
  group_by(
    participant_number,
    block,
    task,
    word_id
  ) %>%
  summarise(n = length(word_id))

# number of duplicated trials in each list
duplicated_trials <- duplicates %>%
  group_by(
    participant_number,
    orthography_condition,
    language_variety
  ) %>%
  summarise(count = length(word_id))

# outputs
#########

# how many words and their duplicates?
paste(
  "Number of words and their duplicates:",
  nrow(original_and_duplicates)
)

# how many words that are duplicated within subjects?
paste(
  "Number of words that are duplicated by subjects:",
  nrow(duplicates_by_subjects)
)

# how many just duplicates?
paste("Total number of duplicates:", nrow(duplicates))

# reset counts and remove duplicates
###################################

# note: mode is used as it *should* give a reliable measure
# of how often the words have been seen in each block
# additionally, it goes by dialect_words to maintain correct counts
# for testing words, which should be different to training words
# dialect words has: shifted, not shifted, and testing words (can_shift)
# so training words (shifted/not) maintain counts in training and testing
# note counts include exposures before training and between training tasks
# thus for training words it starts at 1 and increments by 1 for each block
# and also by 1 for every time it occurs in a training block
# testing words start at 0 and only increment by 1 on each exposure in testing
data <- data %>%
  group_by(participant_number, block, task, dialect_words) %>%
  mutate(exposure_count = Mode(exposure_count))

# remove duplicates (keeps first instance and drops further duplicates), this
# does so for each word_id within each task and block within each participant
# as these items should be unique given this structure
data <- data %>%
  distinct(participant_number, block, task, word_id, .keep_all = TRUE)

# order reconstructed data
###########################

data <- data[with(
  data, 
  order(
    participant_number, 
    session_trial_id, 
    task, 
    block
    ))
  ,]

###############################################################################
# save data checks
###############################################################################

write.table(
  duplicated_trials,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_",
    "duplicates.txt"
  )
)

###############################################################################
# save cleaned data
###############################################################################

save("data",
  "demo_data",
  file = paste0(
    "../",
    folder,
    "/03_cleaned-data/",
    experiments,
    "_",
    "cleaned.Rdata"
  )
)