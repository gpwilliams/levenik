###############################################################################
# Data Refactoring
###############################################################################
# Refactors merged data,
# setting variables to their correct format (e.g. strings to factors).
# Also, generates all columns used for final analyses.
###############################################################################

# Load data
############

load(paste0(
  "../",
  folder,
  "/02_merged-data/",
  experiments,
  "_",
  "merged.Rdata"
))

###############################################################################
# Refactor data
###############################################################################

# set up character, numeric, and integer columns
character_cols <- c(
  "primary_coder_response",
  "secondary_coder_response"
)

numeric_cols <- c(
  "primary_coder_nLED",
  "secondary_coder_nLED"
)

integer_cols <- c(
  "primary_coder_correct",
  "secondary_coder_correct",
  "primary_coder_response_length",
  "secondary_coder_response_length"
)

# transform data types for the above cols
data <- data %>%
  mutate_at(numeric_cols, funs(as.numeric(.))) %>%
  mutate_at(integer_cols, funs(as.numeric(.))) %>%
  mutate_at(character_cols, funs(as.character(.)))

# ordering variables
####################

# convert timestamps from factor to POSIXct
# also make names consistent
demo_data <- demo_data %>%
  mutate(
    start_timestamp = ymd_hms(start_timestamp),
    end_timestamp = ymd_hms(end_timestamp),
    language = str_to_title(language),
    # make mandarin consistent
    language = ifelse(str_detect(language, "Mandarin"),
      "Chinese (Mandarin)", 
      language
    ),
    # make sign languages upper for abbreviation
    # notice sl is lower due to str_to_title call
    language = ifelse(str_detect(language, "sl$"),
      str_to_upper(language), 
      language
    ),
    # make anything in long form sign language to abbreviated form
    language = ifelse(str_detect(language, "Sign Language"),
      paste0(substr(language, 1, 1), "SL"), 
      language
    )
  )

data <- data %>%
  mutate(
    start_timestamp = ymd_hms(start_timestamp),
    timestamp = ymd_hms(timestamp)
  )

# completion time (duration)
demo_data$total_time <- as.duration(demo_data$end_timestamp -
  demo_data$start_timestamp)

# time between trials (difftime)
data <- data %>%
  arrange(session_number, session_trial_id) %>%
  group_by(session_number, section) %>%
  mutate(
    submission_time = c(NA, diff(timestamp)),
    running_time = timestamp - start_timestamp
  ) %>%
  ungroup()

# numerical factor to duration
data$submission_time <- dseconds(data$submission_time)
data$running_time <- dseconds(as.numeric(data$running_time))

# order data by session number (participant), and then their trial ID
data <- data[with(data, order(session_number, session_trial_id)), ]

# dropping variables
####################

# reading and writing data
drop_cols <- c("timestamp", "start_timestamp", "novel_word_for_task")

###############################################################################
# Column creation
###############################################################################

# instantiate columns to change to factors after splitting the section column
to_factors <- c("task", "block")

# split section into task and block
# also, redefine these as factors
data <- data %>%
  select(-one_of(drop_cols)) %>% # drop unnecessary columns
  separate(section, c("task", "block"), "_") %>%
  mutate_at(vars(to_factors), funs(as.factor(.)))

# Generate task trial IDs
#########################

# organise factor levels so testing comes last
data$block <- factor(data$block,
  levels = c(levels(data$block)[-1], "TEST")
)

if (experiments == "ex_0") {
  # make block consistent with other experiments
  # i.e. 11 (block 1 first attempt), and 12 (block 1 second attempt)
  # become just block 1 and 2
  data$block <- dplyr::recode(
    data$block,
    TR11 = "TR1",
    TR12 = "TR2",
    TR21 = "TR3",
    TR22 = "TR4",
    TR31 = "TR5",
    TR32 = "TR6"
  )
}

# get max length and cumulative counts for each block
block_lengths <- data %>%
  group_by(block) %>%
  summarise(length = max(section_trial_id)) %>%
  mutate(cumulative = as.integer(cumsum(length))) %>%
  as.data.frame()

# make incrementing section trial IDs
# this uses direct IDs for all of the training blocks
# (adding previous max number to count)
if (experiments == "ex_1_2") {
  data$task_trial_id <- case_when(
    data$block == "TR1" ~ data$section_trial_id,
    data$block == "TR2" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR1", "cumulative"],
    data$block == "TR3" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR2", "cumulative"],
    data$block == "TEST" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR3", "cumulative"]
  )
} else if (experiments == "ex_3") {
  data$task_trial_id <- case_when(
    data$block == "TR1" ~ data$section_trial_id,
    data$block == "TR2" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR1", "cumulative"],
    data$block == "TR3" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR2", "cumulative"],
    data$block == "TR4" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR3", "cumulative"],
    data$block == "TR5" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR4", "cumulative"],
    data$block == "TR6" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR5", "cumulative"],
    data$block == "TEST" ~ data$section_trial_id +
      block_lengths[block_lengths$block == "TR6", "cumulative"]
  )
} else {
  # no else; task_trial_id == session_trial_id with only 1 task (ex0)
}

# Generate lenient and stringent coding cols for nLED and correct responses
###########################################################################

# recode inconsistent codes for each coder
# make all * or ? combinations consistent
# replacing all repeated ? or * with a single ? or * (respectively)
data$primary_coder_response <- gsub(
  "([?|*])\\1{2,}", "\\1", 
  data$primary_coder_response
)

data$secondary_coder_response <- gsub(
  "([?|*])\\1{2,}", "\\1", 
  data$secondary_coder_response
)

# replace any * or "" submissions (indicating missing data) with NA 
# for primary and secondary coders for nLED and correct responses
data <- data %>%
  mutate_at(vars(
    primary_coder_correct,
    primary_coder_nLED
  ), funs(
    ifelse(
      primary_coder_response == "*" |
        primary_coder_response == "",
      NA,
      .
    )
  ))

data <- data %>%
  mutate_at(vars(
    secondary_coder_correct,
    secondary_coder_nLED
  ), funs(
    ifelse(secondary_coder_response == "*" |
      secondary_coder_response == "",
    NA,
    .
    )
  ))

# make lenient and stringent correct/nLED scores
data <- data %>% 
  mutate(
    lenient_correct = pmax( # max as correct = 1
      primary_coder_correct, 
      secondary_coder_correct, 
      na.rm = TRUE
    ),
    stringent_correct = pmin(
      primary_coder_correct, 
      secondary_coder_correct, 
      na.rm = TRUE     
    ),
    lenient_nLED = pmin( # min as correct = 0
      primary_coder_nLED, 
      secondary_coder_nLED, 
      na.rm = TRUE
    ),
    stringent_nLED = pmax( 
      primary_coder_nLED, 
      secondary_coder_nLED, 
      na.rm = TRUE
    )
  )

# generate maximum word input lengths
# (from word length vs. primary, secondary, and lenient/stringent)
data <- data %>%
  mutate(
    primary_max_word_length = pmax(
      word_length, 
      primary_coder_response_length, 
      na.rm = TRUE
    ),
    secondary_max_word_length = pmax(
      word_length, 
      secondary_coder_response_length, 
      na.rm = TRUE 
    )
  )

# generate lenient max-word lengths ----
# returns index of coder with minimum nLED;
# 1 = primary, 2 = secondary, 3 = both
# warnings if no index can be made (in case of 2 * NA)
# in this instance, NA index becomes 0, which we convert to NA
data$lenient_index <- data %>%
  select(primary_coder_nLED, secondary_coder_nLED) %>%
  pmap(., ~sum(min_max_index(c(.x, .y), "min"))) %>% 
  as.numeric() %>%
  na_if(., 0)

# generate lenient max-word lengths (from primary and secondary max) by index
data <- data %>%
  mutate(
    lenient_max_word_length =
      case_when(
        lenient_index == 1 ~ primary_max_word_length,
        lenient_index == 2 ~ secondary_max_word_length,
        lenient_index == 3 ~ pmin(
          primary_max_word_length, 
          secondary_max_word_length, 
          na.rm = TRUE
        )
      )
  ) %>%
  select(-lenient_index)

# generate stringent max-word lengths ----
# returns index of coder with maximum nLED;
# 1 = primary, 2 = secondary, 3 = both
# warnings if no index can be made (in case of 2 * NA)
# in this instance, NA index becomes 0, which we convert to NA
data$stringent_index <- data %>%
  select(primary_coder_nLED, secondary_coder_nLED) %>%
  pmap(., ~sum(min_max_index(c(.x, .y), "max"))) %>% 
  as.numeric() %>%
  na_if(., 0)

# generate lenient max-word lengths (from primary and secondary max) by index
data <- data %>%
  mutate(
    stringent_max_word_length =
      case_when(
        stringent_index == 1 ~ primary_max_word_length,
        stringent_index == 2 ~ secondary_max_word_length,
        stringent_index == 3 ~ pmax(
          primary_max_word_length, 
          secondary_max_word_length, 
          na.rm = TRUE
        )
      )
  ) %>%
  select(-stringent_index)

# Add identifier for words that are present in training and testing
###################################################################

# define testing words: i.e. those present only in the testing block
testing_words <- c(03, 12, 14, 16, 19, 23, 28, 31, 33, 36, 39, 42)

data$test_words <- as.factor(
  ifelse(
    data$word_id %in% testing_words,
    "testing_word",
    "training_word"
  )
)
# Add identifier for words that shift in the dialect version
############################################################

# training words that shift,
# training that don't shift, and testing words (all can shift)
shifted_words <- c(21, 30, 37, 40, 01, 27, 05, 07, 11, 15, 25, 32, 26, 35, 08)
no_shift_words <- c(02, 04, 06, 09, 10, 13, 17, 18, 20, 22, 24, 29, 34, 38, 41)

data$dialect_words <- as.factor(
  ifelse(data$word_id %in% shifted_words,
    "shifted_word",
    ifelse(data$word_id %in% no_shift_words,
      "no_shift_word",
      "can_shift_word"
    )
  )
)

###############################################################################
# Ordering and renaming columns
###############################################################################

# define data columns
data_cols <- c(
  "trial_id",
  "session_number",
  "session_trial_id",
  "section_trial_id",
  "task_trial_id", # trial IDs
  "language_condition",
  "orthography_condition",
  "picture_condition",
  "order_condition",
  "speaker_condition", # conditions
  "task",
  "block",
  "picture_id",
  "word_id", # conditional identifiers
  "test_words",
  "dialect_words",
  "word_length",
  "exposure_count",
  "target", # stimulus info
  "primary_coder_response",
  "primary_coder_response_length",
  "primary_max_word_length",
  "primary_coder_correct",
  "primary_coder_nLED", # coder DVs
  "secondary_coder_response",
  "secondary_coder_response_length",
  "secondary_max_word_length",
  "secondary_coder_correct",
  "secondary_coder_nLED",
  "lenient_max_word_length", # computed DVs
  "lenient_correct",
  "lenient_nLED",
  "stringent_max_word_length",
  "stringent_correct",
  "stringent_nLED",
  "submission_time", # timing
  "running_time"
)

if (experiments == "ex_0") {
  data_cols <- data_cols[data_cols != "task_trial_id"]
}

# reorder reading and writing data by trials, conditions, and findings
data <- data[, data_cols]

# reorder demo_data
demo_data <- demo_data[, c(
  "session_number",
  "language_condition",
  "orthography_condition",
  "picture_condition",
  "order_condition",
  "speaker_condition",
  "age",
  "gender",
  "language",
  "self_rating",
  "fun",
  "noise",
  "start_timestamp",
  "end_timestamp",
  "total_time"
)]

# rename columns in both reading and writing data
data <- rename(
  data,
  participant_number = session_number,
  language_variety = language_condition,
  target_length = word_length
)

demo_data <- rename(
  demo_data,
  participant_number = session_number,
  language_variety = language_condition,
  language_spoken = language,
  language_proficiency_rating = self_rating,
  fun_rating = fun,
  noise_rating = noise
)

###############################################################################
# Save refactored data
###############################################################################

save(
  "data",
  "demo_data",
  file = paste0(
    "../",
    folder,
    "/02_merged-data/",
    experiments,
    "_",
    "refactored.Rdata"
  )
)