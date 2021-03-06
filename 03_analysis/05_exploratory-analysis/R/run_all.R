# Check Error Types for Contrastive Words ----

# Checks if errors on contrastive words are in the form of dialect words or not.

# Load Libraries and Set Paths ----
libraries <- c("here", "tidyverse", "cowplot", "grid", "gridExtra")

# Uses dev version of stringr in tidyverse at the time of writing. Install with
# devtools::install_github("tidyverse/stringr")
lapply(libraries, library, character.only = TRUE)

# set paths for analyses
data_prep_path <- here(
  "03_analysis", 
  "05_exploratory-analysis", 
  "R", 
  "01a_prepare-data.R"
)
plot_prep_path <- here(
  "03_analysis", 
  "05_exploratory-analysis", 
  "R", 
  "01b_prepare_plotting_elements.R"
)
analysis_path <- here(
  "03_analysis", 
  "05_exploratory-analysis", 
  "R", 
  "02_analysis.R"
)
individual_plots_path <- here(
  "03_analysis", 
  "05_exploratory-analysis", 
  "R", 
  "03a_individual_plots.R"
)
combined_plots_path <- here(
  "03_analysis", 
  "05_exploratory-analysis", 
  "R", 
  "03b_combined_plots.R"
)

# Load Data and Run Checks ---- 

experiments <- 0:3 # define experiments to analyse

# define plot holder (for combining after looping)
plots_out <- vector("list", length(experiments))
names(plots_out) <- paste0("ex_", experiments)
source(plot_prep_path)

for (i in seq_along(experiments)) {
  # get experiment ID for subsetting/testing
  experiment <- experiments[i]
  
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
  message(paste("Running Analyses for Experiment", experiment))
  source(data_prep_path)
  source(analysis_path)
  source(individual_plots_path)
}

# combine plots and save together as one (for appendices)
source(combined_plots_path)

# save session info
saveRDS(
  sessionInfo(),
  file = here(
    "03_analysis", 
    "05_exploratory-analysis", 
    "output", 
    "session_info.RData"
  )
)