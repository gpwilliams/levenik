# Inter-rater reliability and coding checks ----

# Runs checks of IRR (mainly ICC) and
# checks saves anything with missing nLEDS (for manual checks after coding)

# Load Libraries and Set Paths ----
libraries <- c("here", "tidyverse", "irr")

# Uses dev version of stringr at the time of writing. Install with:
# devtools::install_github("tidyverse/stringr")
lapply(libraries, library, character.only = TRUE)

# set paths for analyses
data_prep_path <- here(
  "03_analysis", "01_cross-coding", "R", "01_prepare-data.R"
)
analysis_path <- here("03_analysis", "01_cross-coding", "R", "02_analysis.R")
inconsistencies_path <- here(
  "03_analysis", "01_cross-coding", "R", "03_missing-checks.R"
  )

# Load Data and Run Checks ---- 

experiments <- 0:3 # define experiments to analyse

for (i in seq_along(experiments)) {
  # get experiment ID for subsetting/testing
  experiment <- experiments[i]
  message(paste("Running Analyses for Experiment", experiment))
  
  # load data
  if (experiment == 0) {
    load(here(
      "02_data", 
      "01_study-zero", 
      "03_cleaned-data", 
      "ex_0_filtered.RData"
    ))
  } else if (experiment %in% c(1, 2)) {
    load(here(
      "02_data", 
      "02_study-one-and-two", 
      "03_cleaned-data", 
      "ex_1_2_filtered.RData"
    ))
  } else {
    load(here(
      "02_data", 
      "03_study-three", 
      "03_cleaned-data", 
      "ex_3_filtered.RData"
      ))
  }
  
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
  
  # run cross coding analysis and save output
  source(data_prep_path)
  source(analysis_path)
  source(inconsistencies_path)
}

# save session info
saveRDS(
  sessionInfo(),
  file = here(
    "03_analysis", 
    "01_cross-coding", 
    "output", 
    "session_info.RData"
  )
)