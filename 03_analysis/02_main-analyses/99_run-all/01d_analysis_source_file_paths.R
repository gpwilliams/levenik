# Define Paths ----

# Defines the paths for source data, files, and scripts for running tests.

# Source Files ----

# used as file directories for running models in 
# individual files of the run_all folder

# no separative file for demographics (made during data preparation)

data_preparation_source_files <- here(
  "03_analysis", 
  "02_main-analyses", 
  "01_data-preparation"
)

main_planned_NHST_source_files <- here(
  "03_analysis", 
  "02_main-analyses", 
  "02_planned-analyses",
  "01_NHST"
)

post_hoc_source_files <- here(
  "03_analysis",
  "02_main-analyses",
  "03_post-hoc-analyses", 
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  )
) 

planned_Bayes_source_files <- here(
  "03_analysis",
  "02_main-analyses",
  "02_planned-analyses", 
  "02_Bayes"
) 

multiple_experiment_post_hoc_source_files <- here(
  "03_analysis",
  "02_main-analyses",
  "03_post-hoc-analyses", 
  "05_multiple_experiments"
)