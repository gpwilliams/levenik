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
  "lmerTest",
  "rlang", 
  "lme4", 
  "brms",
  "emmeans"
)

# Uses dev version of stringr at the time of writing. Install with:
# devtools::install_github("tidyverse/stringr")
lapply(libraries, library, character.only = TRUE)

# Load Functions and Set Options ----

# define path to functions and options
source(here(
  "03_analysis", 
  "02_main-analyses", 
  "99_run-all",
  "01a_functions_and_options_paths.R"
))

# load all functions and options
source(analysis_functions_path)
source(run_all_functions_path)
source(options_path)

# load data paths and test paths
source(here("03_analysis", "02_main-analyses", "99_run-all", "01b_data_paths.R"))
source(here("03_analysis", "02_main-analyses", "99_run-all", "01c_run_test_paths.R"))

# Define Tests and Experiments to Run ----

# define experiments to analyse
experiments <- 0:3 # change to one number to run one experiment

# define tests to run
# to_run <- "all" 
# alternative: to_run <- "main_planned_NHST", "all_NHST", "post-hoc", or "planned_Bayes"
to_run <- "post-hoc"

# makes sure data preparation only considers individual experiments
run_three_expt_posthoc <- FALSE 

# Load Data and Run Tests ---- 

for (i in seq_along(experiments)) {
  # get experiment ID for subsetting/testing
  experiment <- experiments[i]
  message(paste("Running Analyses for Experiment", experiment))
  
  # load relevant file paths for the given experiment
  source(here(
    "03_analysis", 
    "02_main-analyses", 
    "99_run-all", 
    "01d_analysis_source_file_paths.R"
  ))
  source(here(
    "03_analysis", 
    "02_main-analyses", 
    "99_run-all", 
    "01e_output_paths.R"
  ))
  
  # load data
  if (experiment == 0) {
    load(ex_zero_data)
  } else if (experiment %in% c(1, 2)) {
    load(ex_one_two_data)
  } else {
    load(ex_three_data)
  }
  
  # these triggers are used to determine if all analyses have been in one 
  # session or if data needs to be prepared again for each set of analyses
  data_prepared <- FALSE 
  main_planned_NHST_run <- FALSE

  # Run analyses

  # Defines orthography for analyses in further scripts;
  #   experiment 0 = opaque, 6 training blocks (read only)
  #   experiment 1 = transparent, 3 training blocks (read & write)
  #   experiment 2 = opaque, 3 training blocks (read & write)
  #   experiment 3 = opaque, 6 training blocks (read & write)
  if (experiment %in% c(0, 2, 3)) {
    orthography <- "opaque"
  } else if (experiment == 1) {
    orthography <- "transparent"
  } else {
    stop("Indexed experiment does not exist.")
  }
  
  # NHST: Main and Planned Comparisons Analyses
  if (to_run %in% c("all", "main_planned_NHST", "all_NHST")) {
    source(tests_main_planned_NHST_path)
  }
  
  # NHST: Post-hoc Comparisons
  if (to_run %in% c("all", "post-hoc", "all_NHST")) {
    source(tests_post_hoc_path)
  }
  
  # Bayes Factors: Planned Comparisons
  # Long compute time, so comes last.
  if (to_run %in% c("all", "planned_Bayes")) {
    source(tests_planned_Bayes_path)
  }
}

# run the first 3 experiment comparison post-hoc ----

if (to_run %in% c("all", "post-hoc", "all_NHST")) {
  message(paste("Running Post-hocs comparing Experiments 0, 1, and 2"))
  run_three_expt_posthoc <- TRUE
  source(tests_multiple_experiment_post_hoc_path)
}

# save session info ----
saveRDS(
  sessionInfo(),
  file = session_info_output_path
)

# Save results with a reduced filesize ----

# gets brms summaries (instead of keeping all draws)
experiments <- 0:3
results <- list()

for (i in seq_along(experiments)) {
  
  # get experiment ID for subsetting/testing
  experiment <- experiments[i]
  
  # define path to specific experiment
  experiments_path <- here(
    "03_analysis", 
    "02_main-analyses", 
    "04_output",
    paste0(
      "0",
      experiment + 1,
      "_experiment-",
      experiment
    )
  )
  
  message(paste("Compressing data for experiment", experiment))
  
  # list file names and paths
  model_file_names <- list.files(experiments_path, pattern = "[.]RData")
  
  model_paths <- here(
    "03_analysis", 
    "02_main-analyses", 
    "04_output",
    paste0("0", experiment + 1, "_experiment-", experiment),
    model_file_names
  )
  
  # model file renames (replaces minus -- illegal in R -- with underscore)
  # and removes the .RData ending
  model_names <- model_file_names %>% 
    str_sub(end = -7) %>%
    str_replace_all("-", "_")
  
  # load models and assign to varying list name with appropriate subnames
  results[[i]] <- purrr::map(model_paths, readRDS) %>%
    purrr::set_names(model_names) # remove file type
  
  # squash Bayesian models down to a summary (removing draws, etc)
  results[[i]]$planned_comparisons_Bayes <- 
    results[[i]]$planned_comparisons_Bayes %>% 
      modify_at(
        c("brm_train", "brm_test", "brm_test_novel"),
        summary
      )
}

# set names for each experiment
results <- results %>% purrr::set_names(paste("experiment", 0:3, sep = "_"))

# read in overall data, assign to list
results$multiple_experiments <- readRDS(
  multiple_experiment_post_hoc_output_path
)

# write to file
saveRDS(
  results,
  file = compressed_results_path
)