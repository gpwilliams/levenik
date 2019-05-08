# Prepare Data ----

# Experiment 0: average over paired blocks (i.e. first exposure and repeat)
if (experiment == 0) {
  data <- data %>%
    mutate(block = case_when(
      block %in% c("TR1", "TR2") ~ "TR1",
      block %in% c("TR3", "TR4") ~ "TR2",
      block %in% c("TR5", "TR6") ~ "TR3",
      block == "TEST" ~ "TEST"
    ))
}

# make more informative/better looking labels for plotting
max_blocks <- length(unique(data$block)) -1

data <- data %>%
  drop_na(lenient_nLED) %>%
  mutate(
    block = factor(
      block,
      levels = c(paste0("TR", seq(1:max_blocks)), "TEST"),
      labels = c(paste(seq(1:max_blocks)), "Test")
    ),
    dialect_words = factor(
      dialect_words,
      levels = c(
        "no_shift_word",
        "shifted_word",
        "can_shift_word"
      ),
      labels = c(
        "Non-Contrastive",
        "Contrastive",
        "Untrained"
      )
    ),
    language_variety = factor(
      language_variety,
      levels = c("standard", "dialect"),
      labels = c("Variety Match", "Variety Mismatch") 
    ),
    # only relevant for experiments 1 and 2 (ex 0 = reading only)
    task = factor(
      task,
      levels = c("R", "W"),
      labels = c("Reading", "Spelling")
    ),
    picture_condition = factor(
      picture_condition,
      levels = c("no_picture", "picture"),
      labels = c("No Picture", "Picture")
    )
  )

# Make Summaries ----

# Subset to Task ----

# we split by both tasks as this affects the error terms
# this splitting reflects our analyses, so is more appropriate

# subset to training only
training_summary <- summariseWithin(
  data = data %>% filter(block != "Test"),
  subj_ID = "participant_number",
  withinGroups = c("block", "task", "dialect_words"),
  betweenGroups = c("picture_condition", "language_variety"),
  dependentVariable = "lenient_nLED",
  errorTerm = "Standard Error"
) %>%
  mutate(block = as.character(block))

# subset to testing only
testing_summary <- summariseWithin(
  data = data %>% filter(block == "Test"),
  subj_ID = "participant_number",
  withinGroups = c("task", "dialect_words"),
  betweenGroups = c("picture_condition", "language_variety"),
  dependentVariable = "lenient_nLED",
  errorTerm = "Standard Error"
) %>%
  mutate(block = "Test") %>%
  select(block, everything())

# combine data for renaming labels
summary_data <- bind_rows(training_summary, testing_summary) %>%
  mutate(
    interacting_factors = 
      interaction(
        task, 
        picture_condition, 
        language_variety, 
        sep = ", "
        )
    ) %>%
  mutate(interacting_factors = sub(',', ':', interacting_factors))

# define level order
level_order <- c(
  "Reading: No Picture, Variety Match", 
  "Reading: No Picture, Variety Mismatch", 
  "Spelling: No Picture, Variety Match", 
  "Spelling: No Picture, Variety Mismatch",
  "Reading: Picture, Variety Match", 
  "Reading: Picture, Variety Mismatch", 
  "Spelling: Picture, Variety Match", 
  "Spelling: Picture, Variety Mismatch"
)

summary_data$interacting_factors <- factor(
  summary_data$interacting_factors,
  levels = level_order
)

# Make by-Subject Descriptives ----

by_subj <- data %>%
  group_by(
    participant_number,
    picture_condition,
    language_variety,
    block,
    task,
    dialect_words
  ) %>%
  summarise(
    m = mean(lenient_nLED, na.rm = TRUE),
    sd = sd(lenient_nLED, na.rm = TRUE),
    n = length(unique(target))
  ) %>%
  ungroup() %>%
  mutate(
    interacting_factors = 
      interaction(
        task, 
        picture_condition, 
        language_variety, 
        sep = ", "
      )
  ) %>%
  mutate(interacting_factors = sub(',', ':', interacting_factors))

if (experiment == 0) {
  by_subj$n <- by_subj$n * 2 # participants saw both words twice
}

by_subj$interacting_factors <- factor(
  by_subj$interacting_factors,
  levels = level_order
)