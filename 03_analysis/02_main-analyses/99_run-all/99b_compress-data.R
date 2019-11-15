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

# load data paths
source(here("03_analysis", "02_main-analyses", "99_run-all", "01b_data_paths.R"))

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
  
  # source output paths for compression
  source(here(
    "03_analysis", 
    "02_main-analyses", 
    "99_run-all", 
    "01e_output_paths.R"
  ))
  
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