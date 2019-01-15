###############################################################################
# Filter Participants
###############################################################################
#
# filter participants from the data
# note: we currently filer participants on their writing task data
# when compared to simulations of the writing task
# as this is the most objective measure
# furthermore, reading data is coded later in the analysis process
# and so cannot be used in these early stages
###############################################################################

# Load data
###########

load(paste0(
  "../",
  folder,
  "/03_cleaned-data/",
  experiments,
  "_",
  "cleaned.Rdata"
))

# load simulation for nLED in the writing task
sim.nLED <- read.csv(paste0(
  "../",
  folder,
  "/04_simulated-data/",
  experiments,
  "_",
  "simulated_nLED.csv"
))

# mean (rounded to 2 dp)
mean_sim_nLED <- round(mean(sim.nLED$nLED), 2)

###############################################################################
# participants dropped due to technical difficulties
###############################################################################

# potentially exclude 178 - repeated previous trial a lot, but stopped later
if (experiments == "ex_0") {
  # further subjects to drop, and why
  technical_difficulty_exclusions <- data.frame(
    participant_number = c(25, 60, 61, 36, 101, 189, 149),
    reason = c(
      "no words spoken/repeats previous trial; exceptionally fast",
      "no words spoken/repeats previous trial; exceptionally fast",
      "no words spoken/repeats previous trial; exceptionally fast",
      "completed incorrect list",
      "completed incorrect list",
      "many trials corrupted (skipping); unidentifiable",
      "completed after list was filled"
    )
  )
} else if (experiments == "ex_1_2") {
  technical_difficulty_exclusions <-
    data.frame(
      participant_number = c(6, 110, 261, 243, 345),
      reason = c(
        "dropped and duplicated trials",
        "no audio, crashing, notes taken",
        "completed EX1 list during EX2 testing phase",
        "completed after list was filled",
        "completed after list was filled"
      )
    )
} else if (experiments == "ex_3") {
  technical_difficulty_exclusions <-
    data.frame(
      participant_number = c(1, 144, 177, 273, 290, 288),
      reason = c(
        "non-native speaker",
        "dropped trials, inaudible recordings",
        "over-recruited list",
        "over-recruited list",
        "did incorrect list (no picture)",
        "over-recruited list"
      )
    )
} else {
  message("error on lines 42-84 of 05_participant_filtering.R")
}

###############################################################################
# check number of dropped trials per participant
###############################################################################

# check unique participants
test_ps <- unique(data$participant_number)

# define empty object for storing outputs
missing_data <- NULL

# subset data for each participant, count number of rows
for (participant in test_ps) {
  test <- subset(
    data,
    data$participant_number == participant
  )
  missing_data <- rbind(missing_data, data.frame(participant, nrow(test)))
}
rm(test) # remove the loop holder

if (experiments == "ex_0") {
  n_items <- 102 # 1 task of 102 trials
} else if (experiments == "ex_1_2") {
  n_items <- 144 # 2 tasks of 144 trials (72 each)
} else if (experiments == "ex_3") {
  n_items <- 204 # 2 tasks of 204 trials (102 each)
} else {
  # do nothing
}

# returns row (session_id) with missing data
dropped_trials <- missing_data[
  apply(missing_data, 1, function(row) {all(row < n_items)})
  , ]

dropped_trials <- select(
  dropped_trials, # rename cols
  c(participant, total_trials_from_max = nrow.test.)
)

rownames(dropped_trials) <- NULL # remove row ID from subsetted data

###############################################################################
# descriptives on individual performance
###############################################################################

# throughout, the lenient coding DVs are used
# grand means for the test section split by task
task_means <- data %>%
  filter(block == "TEST") %>% # filter to test block only
  group_by(participant_number, task) %>%
  summarise(
    mean_nLED = mean(lenient_nLED, na.rm = TRUE),
    sd_nLED = sd(lenient_nLED, na.rm = TRUE),
    mean_correct = mean(primary_coder_correct, na.rm = TRUE),
    sd_correct = sd(primary_coder_correct, na.rm = TRUE)
  )

# define task subsetting (affects titles later on)
participant_means_task <- "R" # set to reading task
participant_means_basis <-
  if (participant_means_task == "W") {
    "writing_data"
  } else if (participant_means_task == "R") {
    "reading_data"
  } else {
    "no_subsetting"
  }

# calculate total time to completion
participant_total_times <- demo_data %>%
  distinct(participant_number, total_time) %>%
  select(participant_number, total_time)

# compute participant means and submission times
participant_means <- data %>%
  filter(block == "TEST" & task == participant_means_task) %>%
  group_by(participant_number, orthography_condition) %>%
  summarise(
    mean_nLED = mean(lenient_nLED, na.rm = TRUE),
    sd_nLED = sd(lenient_nLED, na.rm = TRUE),
    median_submission_time = median(submission_time, na.rm = TRUE)
  ) %>%
  mutate(median_submission_time = as.numeric(median_submission_time)) %>%
  mutate_if(is.numeric, funs(round(., 2))) # round to 2 dp

# add total times to participant means
participant_means <- merge(participant_means, participant_total_times)

# get mean and SD for each orthography (i.e. experiment in ex_1_2)
experiment_means <- data %>%
  filter(block == "TEST") %>% # filter to test block only
  filter(task == participant_means_task) %>% # filter to writing only
  mutate(submission_time = as.numeric(submission_time)) %>%
  group_by(orthography_condition) %>% # split by participant_number
  summarise(
    mean_nLED = mean(lenient_nLED, na.rm = TRUE),
    sd_nLED = sd(lenient_nLED, na.rm = TRUE),
    percentile_submission_time = quantile(
      as.numeric(submission_time),
      na.rm = TRUE, 
      .2
      )
    ) %>%
  mutate_if(is.numeric, funs(round(., 2))) # round to 2 dp

# exclude those with very short submission times and high error rates
performance_exclusions <- participant_means %>%
  filter(
    ifelse(orthography_condition == "transparent",
      median_submission_time <= as.numeric(experiment_means[2, 4]) &
        mean_nLED >= mean_sim_nLED,
      median_submission_time <= as.numeric(experiment_means[1, 4]) &
        mean_nLED >= mean_sim_nLED
    )
  ) %>%
  select(participant_number)

# include reason for exclusion and reformat data
if (nrow(performance_exclusions) > 0) {
  performance_exclusions$reason <-
    "short submission times and overall poor performance"
}
performance_exclusions <- as.data.frame(performance_exclusions)

###############################################################################
# strategy check (read answer from previous submission during training)
###############################################################################

# very lenient lagging strategy;
# checks for exact matches between previous target and current input
target_lag_strategy <- data %>% 
  ungroup() %>%
  filter(block != "TEST") %>%
  select(
    participant_number,
    session_trial_id,
    target,
    primary_coder_response,
    secondary_coder_response
    ) %>%
  mutate(target_lag = lag(target)) %>%
  select(
    participant_number,
    session_trial_id,
    target,
    target_lag,
    everything()) %>%
  na.omit() %>%
  filter(
    target_lag == primary_coder_response |
      target_lag == secondary_coder_response
  ) %>%
  filter(target != target_lag)

###############################################################################
# data filtering
###############################################################################

# merge all reasons for dropping a participant

if (
  any(is.na(technical_difficulty_exclusions$participant_number)) &
    nrow(performance_exclusions) == 0
) {
  # if we have no technical difficulties and no performance exclusions
  dropped_participant_reasons <- "no participants dropped"
} else if (
  any(!is.na(technical_difficulty_exclusions$participant_number)) &
    nrow(performance_exclusions) == 0) {
  # if we only have technical difficulty exclusions
  dropped_participant_reasons <- technical_difficulty_exclusions
} else if (
  any(is.na(technical_difficulty_exclusions$participant_number)) &
    nrow(performance_exclusions) > 0) {
  # if we only have technical performance exclusions
  dropped_participant_reasons <- performance_exclusions
} else {
  # otherwise, bind them together
  dropped_participant_reasons <- rbind(
    performance_exclusions,
    technical_difficulty_exclusions
  )

  # merge those with multiple reasons to be dropped
  if (nrow(dropped_participant_reasons) > 0) {
    dropped_participant_reasons <- aggregate(
      reason ~
      participant_number,
      data = dropped_participant_reasons,
      toString
    )
  }
}

# define group for list calculation
# technical difficulty takes precedence
dropped_participant_reasons$group <- ifelse(
  dropped_participant_reasons$participant_number %in%
    technical_difficulty_exclusions$participant_number,
  "technical_difficulty",
  "performance"
)

###############################################################################
# save participant data checks
###############################################################################

# save participant means and distance from target
write.table(
  participant_means,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_participant_means_based_on_",
    participant_means_basis,
    ".txt"
  ),
  sep = "\t"
)

# save participant task means and distance from target
write.table(
  task_means,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_task_means.txt"
  ),
  sep = "\t"
)

# number of dropped trials split by participant
write.table(
  dropped_trials,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_dropped_trials.txt"
  ),
  sep = "\t"
)

# participants and trials with a target lagging strategy during training
write.csv(
  target_lag_strategy,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_target_lag_strategy.csv"
  )
)

###############################################################################
# subsetting
###############################################################################

# clean up data before subsetting
data <- as.data.frame(data)

# demographics: drop low performing participants
# and those with technical difficulties
sub_demo_data <- subset(
  demo_data, !(participant_number %in%
    dropped_participant_reasons$participant_number)
)

# read write data: drop low performing participants,
# and those with technical difficulties
sub_data <- subset(
  data, !(participant_number %in%
    dropped_participant_reasons$participant_number)
)

demo_data <- subset(
  demo_data, !(participant_number %in%
    technical_difficulty_exclusions$participant_number)
)

# data: drop those with technical difficulties
data <- subset(
  data, !(participant_number %in%
    technical_difficulty_exclusions$participant_number)
)

# output of dropped participants and reasons why
write.csv(
  dropped_participant_reasons,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_dropped_participants_and_reasons.csv"
  )
)

###############################################################################
# save final data
###############################################################################

# save data removing only those with technical difficulties
# reset factor levels for orthography due to people doing incorrect list in ex0
data$orthography_condition <- factor(data$orthography_condition)
demo_data$orthography_condition <- factor(demo_data$orthography_condition)
sub_data$orthography_condition <- factor(sub_data$orthography_condition)
sub_demo_data$orthography_condition <- factor(
  sub_demo_data$orthography_condition
  )

save(
  "data", 
  "demo_data",
  file =
    paste0(
      "../",
      folder,
      "/03_cleaned-data/",
      experiments,
      "_filtered.Rdata"
    )
)

# save data removing those with technical difficulties and low performance
save(
  "sub_data", 
  "sub_demo_data",
  file =
    paste0(
      "../",
      folder,
      "/03_cleaned-data/",
      experiments,
      "_filtered_subsetted.Rdata"
    )
)