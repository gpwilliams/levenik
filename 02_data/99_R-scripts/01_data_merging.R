###############################################################################
# Data Merging and Factor Creation
###############################################################################

# merges reading and writing data and creates a summary of demographics

# this data set retains duplicate trials and all participants
# the above are filtered in later processing stages

# note: when duplicate trials are included,
# novel_word_for_task is incorrect as it relies on a running count of exposures
# as such, we remove novel_word_for_task here,
# and create an identifier (test words) for identifying words which are
# new to the testing phase, or present in training and testing.

# note: for stringent and lenient DVs, if one coder has no input,
# we take the value for the other coder (rather than set to NA)
# if neither has an input, we simply set it to NA.

###############################################################################

# Load Data
###############################################################################

df1 <- read.csv(paste0("../", folder, "/01_raw-data/sessions.csv"),
  strip.white = T
)
df2 <- read.csv(paste0("../", folder, "/01_raw-data/sessions_languages.csv"),
  strip.white = T,
  colClasses = c("NULL", NA, NA, NA) # drop first col
)
df3 <- read.csv(paste0("../", folder, "/01_raw-data/reading_task.csv"),
  strip.white = T
)
df4 <- read.csv(paste0("../", folder, "/01_raw-data/reading_coding.csv"),
  strip.white = T
)
if (experiments != "ex_0") {
  df5 <- read.csv(paste0("../", folder, "/01_raw-data/writing_task.csv"),
    strip.white = T
  )
} # only load writing data for experiments with a writing task

# Filter data
#############

# dropping our dummy age for testing the experiment (999)
# and those who didn't complete the experiment. Make picture a factor.
df1 <- df1 %>%
  filter(progress == "END" & age != 999) %>%
  mutate(
    picture_condition =
      factor(
        picture_condition,
        levels = c(0, 1),
        labels = c("no_picture", "picture")
      )
  )

###############################################################################
# Create demographic data
###############################################################################

# the below are reliant on df1, which has been filtered to
# completed trials (and non-dummy trials) and is used
# later for merging with reading/writing to drop unfinished and dummy trials

# conditions used to merge with demographic data
questions_data <- subset(df1,
  select = c(
    "session_number",
    "language_condition",
    "orthography_condition",
    "picture_condition",
    "order_condition",
    "speaker_condition",
    "start_timestamp",
    "end_timestamp",
    "age",
    "gender",
    "fun",
    "noise"
  )
)

# conditions used to merge with reading, writing, and reading & writing data
conds_data <- subset(df1,
  select = c(
    "session_number",
    "language_condition",
    "orthography_condition",
    "picture_condition",
    "order_condition",
    "speaker_condition",
    "start_timestamp",
    "end_timestamp"
  )
)

# merge demographic data and languages spoken data
demo_data <- merge(questions_data, df2)

###############################################################################
# Create reading data
###############################################################################

# drop code_id col, rename timestamp for merging (need unique ID)
reading_coding <- df4 %>%
  select(-code_id) %>%
  rename(coder_timestamp = timestamp)

# drop the DVs from reading data, use only those from reading_coding data
# reading data only contained those from the most recent coder; coding has all
reading_trials <- df3 %>%
  select(-participant_input, -correct, -edit_distance)

# merge reading data and reading coder data
# all = TRUE to ensure full outer join of data,
# i.e. if data is only present in one dataframe, still keep it
# this allows us to see if something hasn't been coded
# (e.g. in instances of missing audio etc.)
reading_data <- merge(reading_trials, reading_coding, all = TRUE)

# generate lengths for coded response (15 is their input)
coded_response <- reading_data %>%
  select(coded_response) %>%
  mutate(length = apply(reading_data, 1, function(x) nchar(x[15])))

# add lengths to full data
reading_data$coded_response_length <- coded_response$length
rm(coded_response) # clean up

# Order Reading Data
####################

# merge with demo data to remove any non-completed sessions and test sessions
reading_data <- merge(reading_data, conds_data)

# keep only the most recently coded items for each coder
# order so most recent codes are first
# drop any codes below (prior in time to) the most recent codes by these cols
reading_data <- reading_data %>%
  arrange(desc(coder_timestamp)) %>%
  distinct(
    session_number,
    section,
    session_trial_id,
    coder,
    .keep_all = TRUE
  ) %>%
  arrange(session_number, section, session_trial_id)

# reorder reading data so columns to spread come last
# drop coder_timestamp and end_timestamp
reading_data <- reading_data[
  ,
  c(
    "start_timestamp",
    "timestamp",
    "trial_id",
    "session_number", # trial IDs
    "section",
    "session_trial_id",
    "section_trial_id",
    "picture_id",
    "novel_word_for_task",
    "exposure_count", # item info
    "word_length",
    "word_id",
    "target",
    "coder",
    "language_condition",
    "orthography_condition", # condition info
    "picture_condition",
    "order_condition",
    "speaker_condition",
    "coded_response",
    "coded_response_length",
    "edit_distance", # DVs
    "correct"
  )
]

# prepare for wide formatting
############################

# make coded_response a string for wide format data
reading_data$coded_response <- as.character(reading_data$coded_response)

# wide format data
reading_data <- reading_data %>%
  gather(var, val, coded_response:correct) %>%
  unite(var2, coder, var) %>%
  spread(var2, val)

# keep only primary and secondary coder DVs
reading_data <- reading_data %>%
  select(-matches("NA|Nik|unknown"))

# rename column headings for DVs
reading_data <- reading_data %>%
  rename_at(
    vars(starts_with("glenn")),
    funs(sub("glenn", "primary_coder", .))
  ) %>%
  rename_at(
    vars(starts_with("vera")),
    funs(sub("vera", "secondary_coder", .))
  ) %>%
  rename_at(
    vars(ends_with("edit_distance")),
    funs(sub("edit_distance", "nLED", .))
  ) %>%
  rename_at(
    vars(contains("coded_response")),
    funs(sub("coded_response", "response", .))
  )

###############################################################################
# Create writing data
###############################################################################

if(experiments != "ex_0") {
  # merge writing data with condition data
  writing_data <- merge(df5, conds_data)
  
  # generate participant input length
  ###################################
  
  # extract lengths of letters for participant_input
  # generate lengths from their input (col 13)
  participant_input <- writing_data %>%
    select(participant_input) %>%
    mutate(length = apply(
      writing_data, 1, function(x) nchar(x[13])
    )) %>%
    select(length)
  
  # add lengths to full data
  writing_data$participant_input_length <- participant_input$length
  rm(participant_input) # clean up
  
  # rename old DV cols as the primary coder for merging;
  # copy to secondary coder (i.e. identical values)
  # note: also changing edit_distance to nLED here (as with speaking data)
  # this allows for merging reading and writing data into one table
  writing_data <- writing_data %>%
    rename(
      primary_coder_response = participant_input,
      primary_coder_response_length = participant_input_length,
      primary_coder_correct = correct,
      primary_coder_nLED = edit_distance
    ) %>%
    mutate(
      secondary_coder_response = primary_coder_response,
      secondary_coder_response_length = primary_coder_response_length,
      secondary_coder_correct = primary_coder_correct,
      secondary_coder_nLED = primary_coder_nLED
    )
  
  # drop end_timestamp (for consistent cols across reading/writing)
  writing_data <- writing_data %>% select(-end_timestamp)
}

###############################################################################
# Merge reading and writing data
###############################################################################

# merge reading and writing data
if(experiments != "ex_0") {
  data <- rbind(reading_data, writing_data)
} else {
  data <- reading_data
}

save(
  "data",
  "demo_data",
  file =
    paste0(
      "../",
      folder,
      "/02_merged-data/",
      experiments,
      "_",
      "merged.RData"
    )
)