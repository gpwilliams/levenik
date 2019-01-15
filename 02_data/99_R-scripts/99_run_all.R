# Runs all scripts one after the other
###############################################################################

# load required packages; install with install.packages() if necessary
required_packages <- c(
  "tidyverse",
  "stringdist",
  "lubridate",
  "irr",
  "ggforce"
)

lapply(required_packages, library, character.only = TRUE)

sourced_files <- c(
  "00_refactoring_functions.R",
  "01_data_merging.R",
  "02_data_refactoring.R",
  "03_data_cleaning.R",
  "04_simulate_random_input.R",
  "05_participant_filtering.R",
  "06_list_counts.R",
  "07_participant_performance_plots.R",
  "08_cross_coding_checks.R"
)

# define experiments
all_experiments <- c("ex_0", "ex_1_2", "ex_3")

# define experiment name holder and folder path
for (i in seq_along(all_experiments)) {
  experiments <- all_experiments[i]
  
  folder <- case_when(
    all_experiments[i] == "ex_0" ~ "01_study-zero"
    all_experiments[i] == "ex_1_2" ~ "02_study-one-and-two"
    all_experiments[i] == "ex_3" ~ "03_study-three"
  )

  # run all files in order
  for (j in seq_along(sourced_files)) {
    source(sourced_files[j])
  }
}
message("all done!")