# Run all analysis code ----

# prepares all data and runs planned & post-hoc analyses for each experiment.

# Notes ----

# note broom::tidy() does not currently work with models from lmerTest
# therefore we use broom.mixed::tidy() from GitHub for lmerTest objects
# devtools::install_github("bbolker/broom.mixed")
# p-values for mixed models reported using Satterthwaite's method in lmerTest

# Load Libraries ----
libraries <- c(
  "here",
  "tidyverse", 
  "broom.mixed", 
  "rlang", 
  "lme4", 
  "lmerTest",
  "afex",
  "brms",
  "emmeans"
)

lapply(libraries, library, character.only = TRUE)

# Load Functions and Set Options ----

# define path to functions
analysis_functions_path <- here(
  "03_analysis", 
  "03_main-analyses", 
  "00_functions", 
  "analysis_functions.R"
)

run_all_functions_path <- here(
  "03_analysis", 
  "03_main-analyses", 
  "00_functions", 
  "run_all_functions.R"
)

options_path <- here(
  "03_analysis", 
  "03_main-analyses", 
  "99_run-all", 
  "00_options.R"
)

source(analysis_functions_path)
source(run_all_functions_path)
source(options_path)

# Define Tests and Experiments to Run ----

# define experiments to analyse
# define tests to run
# to_run <- "all" 
# alternative: to_run <- "main_planned_NHST", "post-hoc", or "planned_Bayes"
to_run <- "all_NHST" # (main, planned, post-hoc without Bayes)

# Load Data and Run Tests ---- 

# get experiment ID for subsetting/testing
experiment <- 3

# load relevant file paths for the given experiment
source(here("03_analysis", "03_main-analyses", "99_run-all", "01_file_paths.R"))

# load data
if (experiment == 0) {
  load(ex_zero_data)
} else if (experiment %in% c(1, 2)) {
  load(ex_one_two_data)
} else {
  load(ex_three_data)
}

# Defines orthography for analyses in further scripts;
if (experiment %in% c(0, 2, 3)) {
  orthography <- "opaque"
} else if (experiment == 1) {
  orthography <- "transparent"
} else {
  stop("Indexed experiment does not exist.")
}

# these triggers are used to determine if all analyses have been in one 
# session or if data needs to be prepared again for each set of analyses
data_prepared <- FALSE 
main_planned_NHST_run <- FALSE
prepare_data(where = data_preparation_source_files, skip = data_prepared)
data_prepared <- TRUE # skip preparation later if still TRUE

# set contrasts for TRAINING
contrasts(training$language_variety) <- contr.sum(2)
contrasts(training$dialect_words) <- contr.sum(2)

if(experiment %in% c(0, 1, 2)) {
  contrasts(training$picture_condition) <- contr.sum(2)
}

if(experiment > 0) {
  contrasts(training$task) <- contr.sum(2)
}

# set contrasts for TESTING
contrasts(testing$dialect_words)
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

# Run analyses ----

# TRAINING ----

if (experiment == 0) {
  train_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    poly(block_num, 2) * picture_condition * language_variety +
    picture_condition:language_variety:dialect_words +
    poly(block_num, 2):picture_condition:language_variety:dialect_words +
    (language_variety_c * picture_condition_c | target) +
    ((ot1 + ot2) * dialect_words_c | participant_number)"
  ))
}

# for Ex 1-2
if (experiment %in% c(1, 2)) {
  train_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    poly(block_num, 1) * task * picture_condition * language_variety/dialect_words +
    task * picture_condition * language_variety/dialect_words +
    (1 + task_c * language_variety_c * picture_condition_c | target) +
    (1 + ot1 * task_c * dialect_words_c | participant_number)"
  ))
}

if (experiment == 3) {
  # for Ex 3
  train_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    poly(block_num, 2) * task * language_variety +
    task:language_variety:dialect_words +
    poly(block_num, 2):task:language_variety:dialect_words +
    (1 + language_variety_c * task_c | target) +
    (1 + (ot1 * ot2) * task_c * dialect_words_c | participant_number)"
  ))
}

training_lm <- lmer(
  train_max_model, 
  data = training,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
) 
summary(training_lm)

# TESTING ----

# for Ex0

if (experiment == 0) {
  test_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    picture_condition*language_variety/dialect_words +
    (1 + picture_condition_c * language_variety_c | target) +
    (1 + (dialect_words_c + test_words_c) | participant_number)"
  ))
}

# for Ex 1-2
if (experiment %in% c(1, 2)) {
  test_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    task*picture_condition*language_variety/dialect_words +
    (1 + language_variety_c * picture_condition_c * task_c | target) +
    (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
  ))
}

if (experiment == 3) {
  # for Ex 3
  test_max_model <- as.formula(paste(
    dv_transformed,
    "~ 
    task*language_variety/dialect_words +
    (1 + language_variety_c * task_c | target) +
    (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
  ))
}

test_max_model <- as.formula(paste(
  dv_transformed,
  "~ 
    task*language_variety/dialect_words +
    (1 + language_variety_c * task_c | target) +
    (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
))

# lme4 ----

testing_lm <- lmer(
  test_max_model, 
  data = testing,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
) 
summary(testing_lm)
VarCorr(testing_lm)

# BRMS ----

# finding reasonable values (get limits)
asin(sqrt(1)) - asin(sqrt(.001)) # ranges roughly 1.55 max diff in scores

# plotting priors

# intercept; mainly positive, with 95% mass between 1.54 and - .05
curve(dnorm(x, mean = 0.75, sd = .4), from = -2, to = 2) 

# centred on 0, with 95% mass between 1.54 and -1.54
curve(dnorm(x, mean = 0, sd = 5), from = -10, to = 10) # suuuuper wide
curve(dnorm(x, mean = 0, sd = .77), from = -2, to = 2)
curve(dnorm(x, mean = 0, sd = .2), from = -2, to = 2) # happy with this (matches previous findings)

# maybe informative priors showing small effects is better, 
# still always assume 0, but assume small effects on coefficients
# i.e. sd 0.2, and for intercept have mean .75 but sd of .2?

# problem seems to be using unscaled parameters
# arcsine square root is really unintuitive for setting priors (e.g. 18 isn't 1, but 1.4 is near 1)
testing$asin_scale <- scale(testing$asin) # this does it correctly

# check mean is 0 and sd is 1, then fit to lme4 and see what the intercept is (probably 0)
# then fit normal(0, 1) priors

test_max_model <- as.formula(
  "asin_scale ~ 
  task*language_variety/dialect_words +
  (1 + language_variety_c * task_c | target) +
  (1 + task_c * (dialect_words_c + test_words_c) | participant_number)"
)

priors_mixed <- c(
  # default priors at time of execution:
  set_prior("student_t(3, 0, 10)", class = "sd"),
  set_prior("student_t(3, 0, 10)", class = "sigma"),
  
  # user-defined priors:
  
  # generic weakly informative prior
  set_prior("normal(0, 1)", class = "Intercept"), 
  
  # LKJ(2) used to reduce plausibility of perfect correlations
  set_prior("lkj_corr_cholesky(2)", class = "L"),
  
  # informative prior: small effects - 0, with 95% prob up to .4
  set_prior("normal(0, .2)", class = "b") 
)

cores <- parallel::detectCores()

testing_brm <- brm(
  test_max_model, 
  data = testing, 
  save_all_pars = TRUE, 
  prior = priors_mixed,
  sample_prior = TRUE,
  iter = 2000, 
  cores = cores,
  # increased max treedepth due to warnings at default of 10
  control = list(max_treedepth = 10) 
)

# inspect model
testing_brm

# bayes factor for null results
hypotheses <- c(
  "task1 = 0",
  "language_variety1 = 0",
  "task1:language_variety1 = 0", 
  "taskR:language_varietydialect:dialect_words1 = 0", 
  "taskW:language_varietydialect:dialect_words1 = 0", 
  "taskR:language_varietystandard:dialect_words1 = 0", 
  "taskW:language_varietystandard:dialect_words1 = 0", 
  "taskR:language_varietydialect:dialect_words2 = 0",
  "taskW:language_varietydialect:dialect_words2 = 0",
  "taskR:language_varietystandard:dialect_words2 = 0",
  "taskW:language_varietystandard:dialect_words2 = 0"
)

brms_hypotheses <- hypothesis(testing_brm, hypotheses)
brms_hypotheses

# testing for ex3 at the moment...

# try training now....
training$asin_scale <- scale(training$asin)

train_max_model <- as.formula(
  "asin_scale ~ 
    (ot1 + ot2) * task * language_variety +
    task:language_variety:dialect_words +
    (ot1 + ot2):task:language_variety:dialect_words +
    (1 + language_variety_c * task_c | target) +
    (1 + (ot1 * ot2) * task_c * dialect_words_c | participant_number)"
)

priors_mixed <- c(
  # default priors at time of execution:
  set_prior("student_t(3, 0, 10)", class = "sd"),
  set_prior("student_t(3, 0, 10)", class = "sigma"),
  
  # user-defined priors:
  set_prior("normal(0, 1)", class = "Intercept"), # generic weakly informative prior
  
  # LKJ(2) used to reduce plausibility of perfect correlations
  set_prior("lkj_corr_cholesky(2)", class = "L"),
  
  # informative prior; expect weak effects
  set_prior("normal(0, 0.2", class = "b"), 
  
  # wide, very weakly informative priors on both time terms
  set_prior("normal(0, 10)", group = "ot1"), 
  set_prior("normal(0, 10)", group = "ot2")
  )

# alternative = try 0 + Intercept in RHS of model to avoid recentering

cores <- parallel::detectCores()

training_brm <- brm(
  train_max_model, 
  data = training, 
  save_all_pars = TRUE, 
  prior = priors_mixed,
  sample_prior = TRUE,
  iter = 2000, 
  cores = cores,
  # increased max treedepth due to warnings at default of 10
  control = list(max_treedepth = 10) 
)

training_brm

training_hypotheses <- c(
  "ot1 = 0",
  "ot2 = 0",
  "task1 = 0",
  "language_variety1 = 0",
  "ot1:task1 = 0",
  "ot2:task1 = 0",
  "ot1:language_variety1 = 0",
  "ot2:language_variety1 = 0",
  "task1:language_variety1 = 0", 
  "taskR:language_varietydialect:dialect_words1 = 0", 
  "taskW:language_varietydialect:dialect_words1 = 0", 
  "taskR:language_varietystandard:dialect_words1 = 0", 
  "taskW:language_varietystandard:dialect_words1 = 0", 
  "ot1:taskR:language_varietydialect:dialect_words1 = 0",
  "ot2:taskR:language_varietydialect:dialect_words1 = 0",
  "ot1:taskW:language_varietydialect:dialect_words1 = 0",
  "ot2:taskW:language_varietydialect:dialect_words1 = 0",
  "ot1:taskR:language_varietystandard:dialect_words1 = 0",
  "ot2:taskR:language_varietystandard:dialect_words1 = 0",
  "ot1:taskW:language_varietystandard:dialect_words1 = 0",
  "ot2:taskW:language_varietystandard:dialect_words1 = 0"
)

training_brms_hypotheses <- hypothesis(training_brm, training_hypotheses)
training_brms_hypotheses

save(training_brm, training_hypotheses, file = "training_brm_ex3.RData")
fixef(training_brm) # get just fixed effects

# coefficients don't really matter for time terms; we only care about langauge variety and word type interactions.