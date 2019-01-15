# Define Paths ----

# Defines the paths for source data, files, and scripts for running tests.

# Notes ----

# A path is hard coded into the run_all_functions code for the
# prepare_data() function.

# Source Data Paths ----

# used to load data in run_all.R for each experiment

ex_zero_data <- here(
  "02_data",
  "01_study-zero",
  "03_cleaned-data", 
  "ex_0_filtered.RData"
  )

ex_one_two_data <- here(
  "02_data",
  "02_study-one-and-two",
  "03_cleaned-data",
  "ex_1_2_filtered.RData"
)

ex_three_data <- here(
  "02_data",
  "03_study-three",
  "03_cleaned-data", 
  "ex_3_filtered.RData"
)

# Paths for Loading and Saving Models ----

# Source Files ----

# used as file directories for running models in 
# individual files of the run_all folder

# no separative file for demographics (made during data preparation)

data_preparation_source_files <- here(
  "03_analysis", 
  "03_main-analyses", 
  "01_data-preparation"
)

main_planned_NHST_source_files <- here(
  "03_analysis", 
  "03_main-analyses", 
  "02_planned-analyses",
  "01_NHST"
)

post_hoc_source_files <- here(
  "03_analysis",
  "03_main-analyses",
  "03_post-hoc-analyses", 
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  )
) 

post_hoc_ex_1_to_3_source_files <- here(
  "03_analysis",
  "03_main-analyses",
  "03_post-hoc-analyses", 
  "05_experiments-1-to-3"
)

planned_Bayes_source_files <- here(
  "03_analysis",
  "03_main-analyses",
  "02_planned-analyses", 
  "02_Bayes"
) 

# Output Paths ----

# used as output paths in individual files of the run_all folder

demographics_output_path <- here(
  "03_analysis",
  "03_main-analyses",
  "04_output",
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  ),
  "demographics.RData"
)

main_models_output_path <- here(
  "03_analysis",
  "03_main-analyses",
  "04_output",
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  ),
  "main-models.RData"
)

planned_comparisons_NHST_output_path <- here(
  "03_analysis",
  "03_main-analyses",
  "04_output",
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  ),
  "planned-comparisons_NHST.RData"
)

post_hoc_output_path <- here(
  "03_analysis",
  "03_main-analyses",
  "04_output",
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  ),
  "post-hoc-comparisons.RData"
)

planned_Bayes_output_path <- here(
  "03_analysis",
  "03_main-analyses",
  "04_output",
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  ),
  "planned-comparisons_Bayes.RData"
)

planned_Bayes_agg_output_path <- here(
  "03_analysis",
  "03_main-analyses",
  "04_output",
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  ),
  "planned-comparisons_Bayes_agg.RData"
)

session_info_output_path <- here(
  "03_analysis",
  "03_main-analyses",
  "04_output",
  "session_info.R"
)

# Paths for Running Tests ----

# used in the 99_run-all.R file

tests_main_planned_NHST_path <- here(
  "03_analysis",
  "03_main-analyses",
  "99_run-all",
  "02_run_main_planned_NHST.R"
)

tests_post_hoc_path <- here(
  "03_analysis",
  "03_main-analyses",
  "99_run-all",
  "03_run_post-hoc.R"
)

tests_planned_Bayes_path <- here(
  "03_analysis",
  "03_main-analyses",
  "99_run-all",
  "04_run_planned_Bayes.R"
)