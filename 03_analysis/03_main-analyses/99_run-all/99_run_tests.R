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
  "BayesFactor",
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
experiments <- 0:3 # change to one number to run for one experiment

# define tests to run
# to_run <- "all" 
# alternative: to_run <- "main_planned_NHST", "all_NHST", "post-hoc", or "planned_Bayes"
to_run <- "planned_Bayes"

# Load Data and Run Tests ---- 

for (i in seq_along(experiments)) {
  # get experiment ID for subsetting/testing
  experiment <- experiments[i]
  message(paste("Running Analyses for Experiment", experiment))
  
  # load relevant file paths for the given experiment
  source(
    here("03_analysis", "03_main-analyses", "99_run-all", "01_file_paths.R")
    )
  
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

  # Run analyses ----

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

# save session info
saveRDS(
  sessionInfo(),
  file = session_info_output_path
)