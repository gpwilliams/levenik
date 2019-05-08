# make new plots ----

# load libraries
library(tidyverse)
library(here)

# load functions
source(here("04_figures", "functions", "normalise_within_subjects_error.R"))
source(here("04_figures", "functions", "geom_flat_violin.R"))

# define experiments
experiments <- c(0:3)

# make training and testing plots for all experiments ----
for (i in seq_along(experiments)) {
  experiment <- experiments[i]
  
  # set default tasks
  tasks <- c("Reading", "Spelling")
  
  # load data and filter to correct orthography (if necessary)
  if (experiment == 0) {
    # reset tasks to just reading if Experiment 0 (reading only)
    tasks <- "Reading"
    
    load(
      here(
        "02_data", 
        "01_study-zero", 
        "03_cleaned-data", 
        "ex_0_filtered.RData"
      )
    )
  } else if (experiment %in% c(1, 2)) {
    load(
      here(
        "02_data", 
        "02_study-one-and-two", 
        "03_cleaned-data", 
        "ex_1_2_filtered.RData"
      )
    )
    
  } else {
    load(
      here(
        "02_data", 
        "03_study-three", 
        "03_cleaned-data", 
        "ex_3_filtered.RData"
      )
    )
  }
  
  # subset data for experiments 1 and 2
  if (experiment == 1) {
    data <- data %>% filter(orthography_condition == "transparent")
  } else if (experiment == 2) {
    data <- data %>% filter(orthography_condition == "opaque")
  } else {
    # do nothing
  }
  
  # run files
  source(here("04_figures", "R", "training_testing_plots", "01_prepare-data.R"))
  
  for (each_task in seq_along(tasks)) {
    this_task <- tasks[each_task]
    source(here(
      "04_figures", 
      "R", 
      "training_testing_plots", 
      "02_plotting-variables.R"
    ))
    
    source(here(
      "04_figures", 
      "R", 
      "training_testing_plots", 
      "03_training-plot.R"
    ))
    
    source(here(
      "04_figures", 
      "R", 
      "training_testing_plots", 
      "04_testing-plot.R"
    ))
  }

  print(paste0("Making plots for Experiment ", experiment, "."))
}
print("All done!")

# make additional plot from experiments 0-2 looking at word novelty
