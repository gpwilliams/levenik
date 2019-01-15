# Data Preparation for NHST & Bayesian Analyses ----

# Centre variables properly and generate polynomials for training for fitting
# in lme4 with crossed random effects of subjects/items.

# Main Models ----

# convert block to numeric for calculating orthogonal polynomials of block
# make participant number and target a factor for lme4 and Bayes factor
# random effects
data <- data %>%
  mutate(
    block_num = as.numeric(block),
    target = as.factor(target),
    participant_number = as.factor(participant_number)
  ) %>%
  filter(!is.na(!!sym(dv))) %>% # filter out NA; analyses fail when present
  make_asinsqrt(., dv)

# Split data into training and testing, keep only required orthography
# reset levels of orthography
# remove datetimes (stops coercion warnings when fitting models)
training <- data %>%
  filter(orthography_condition == orthography & block != "TEST") %>%
  mutate(orthography_condition = factor(orthography_condition)) %>%
  select(-c(submission_time, running_time))

testing <- data %>%
  filter(orthography_condition == orthography & block == "TEST") %>%
  mutate(orthography_condition = factor(orthography_condition)) %>%
  select(-c(submission_time, running_time))

# reset levels to remove dropped levels for block/dialect words
training <- training %>% mutate_at(c("dialect_words", "block"), factor)
testing <- testing %>% mutate(block = factor(block))

# make orthogonal polynomial time term for training
if (experiment == 0 | experiment == 3) {
  # 6 blocks; linear and quadratic orthogonal time terms (ot1/ot2)
  polynomials <- poly(1:max(training$block_num), 2)
  training[, paste0("ot", 1:2)] <- polynomials[training$block_num, 1:2]
} else if (experiment > 0) {
  # 3 blocks; linear orthogonal time term (ot1) only
  polynomials <- poly(1:max(training$block_num), 1)
  training$ot1 <- polynomials[training$block_num, 1]
}

# establish list of variables to be centred (and which level to be positive)
training_list <-
  list(
    factors = c(
      "task",
      "picture_condition",
      "language_variety",
      "dialect_words"
    ),
    levels = c(
      "R",
      "picture",
      "standard",
      "shifted_word"
    )
  )

testing_list <- list(
  factors = c(
    "task",
    "picture_condition",
    "language_variety",
    "dialect_words",
    "test_words"
  ),
  levels = c(
    "R",
    "picture",
    "standard",
    "can_shift_word",
    "testing_word"
  )
)

# remove task if experiment is experiment 0 (only reading task)
if (experiment == 0) {
  # removing 1st elements (no task in ex0); order matters
  training_list <- map(training_list, function(x) x[-1]) 
  testing_list <- map(testing_list, function(x) x[-1])
} else if (experiment == 3) {
  # removing 2nd elements (no picture conditions in ex3); order matters
  training_list <- map(training_list, function(x) x[-2]) 
  testing_list <- map(testing_list, function(x) x[-2])
}

# centre levels
training <- centre_many(training, training_list)
testing <- centre_many(testing, testing_list)

# set can_shift_words (testing words) to NA so that dialect_words
# ignores the testing words. Then centre all variables
# and reset can_shift_words to 0 (so it is included, but ignored from models)
# comparing effects of dialect_words
# dialect words centered (2 mutate calls to enforce order of execution)
testing <- testing %>%
  mutate(
    dialect_words = replace(
      dialect_words,
      dialect_words == "can_shift_word",
      NA
      )) %>%
  mutate(dialect_words_c = centre_var(., "dialect_words", "shifted_word")) %>%
  replace_na(list(dialect_words_c = 0, dialect_words = "can_shift_word"))

# sum and helmert code appropriate factors

# set contrasts for training
contrasts(training$language_variety) <- contr.sum(2)
contrasts(training$dialect_words) <- contr.sum(2)

if(experiment %in% c(0, 1, 2)) {
  contrasts(training$picture_condition) <- contr.sum(2)
}

if(experiment > 0) {
  contrasts(training$task) <- contr.sum(2)
}

# set contrasts for testing

# order levels prior to helmert coding for correct comparisons
testing$dialect_words <- factor(
  testing$dialect_words, 
  levels = c(
    "shifted_word", "no_shift_word", "can_shift_word"
  )
)

contrasts(testing$language_variety) <- contr.sum(2)
contrasts(testing$dialect_words) <- contr.helmert(3)

if(experiment %in% c(0, 1, 2)) {
  contrasts(testing$picture_condition) <- contr.sum(2)
}

if(experiment > 0) {
  contrasts(testing$task) <- contr.sum(2)
}