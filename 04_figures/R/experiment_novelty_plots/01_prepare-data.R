# Prepare Data ----

# load data ----

# load experient 0 data
load(
  here(
    "02_data", 
    "01_study-zero", 
    "03_cleaned-data", 
    "ex_0_filtered.RData"
  )
)
# set name to avoid overwriting on next load
ex0_data <- data %>%
  mutate(experiment = "Experiment 1")

load(
  here(
    "02_data", 
    "02_study-one-and-two", 
    "03_cleaned-data", 
    "ex_1_2_filtered.RData"
  )
)

ex1_2_data <- data %>% 
  select(-task_trial_id) %>%
  mutate(experiment = case_when(
    orthography_condition == "transparent" ~ "Experiment 2a",
    orthography_condition == "opaque" ~ "Experiment 2b"
  ))

# using rbind as bind_rows breaks lubridate cols
all_data <- rbind(ex0_data, ex1_2_data)
rm(data, demo_data, ex0_data, ex1_2_data) # clean up workspace

# format data ----

all_data <- all_data %>%
  filter(block == "TEST", task == "R") %>%
  drop_na(lenient_nLED) %>%
  mutate(
    test_words = factor(
      test_words,
      levels = c(
        "training_word",
        "testing_word"
      ),
      labels = c(
        "Trained",
        "Untrained"
      )
    )
  )

# Make Summaries ----

# subset to testing only
summary_data <- summariseWithin(
  data = all_data,
  subj_ID = "participant_number",
  withinGroups = "test_words",
  betweenGroups = "experiment",
  dependentVariable = "lenient_nLED",
  errorTerm = "Standard Error"
) %>%
  mutate(block = "Test") %>%
  select(block, everything()) %>%
  mutate(interacting_factor = interaction(experiment, test_words, sep = ": "))

# Make by-Subject Descriptives ----

by_subj <- all_data %>%
  group_by(participant_number, experiment, test_words) %>%
  summarise(
    m = mean(lenient_nLED, na.rm = TRUE),
    sd = sd(lenient_nLED, na.rm = TRUE),
    n = length(unique(target))
  ) %>%
  ungroup() %>%
  mutate(interacting_factor = interaction(experiment, test_words, sep = ": "))

# order the interacting factor (which is needed for splitting dots in plot)
# by each combination of the factors otherwise dots overlap

# define level order
level_order <- c(
  "Experiment 1: Trained", 
  "Experiment 1: Untrained", 
  "Experiment 2a: Trained", 
  "Experiment 2a: Untrained", 
  "Experiment 2b: Trained", 
  "Experiment 2b: Untrained"
)

summary_data$interacting_factor <- factor(
  summary_data$interacting_factor,
  levels = level_order
)

by_subj$interacting_factor <- factor(
  by_subj$interacting_factor,
  levels = level_order
)