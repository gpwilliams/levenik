# Define Paths ----

# Defines the paths for source data, files, and scripts for running tests.

# Notes ----

# A path is hard coded into the run_all_functions code for the
# prepare_data() function.

# Paths for Running Tests ----

# used in the 99_run-all.R file

tests_main_planned_NHST_path <- here(
  "03_analysis",
  "02_main-analyses",
  "99_run-all",
  "02_run_main_planned_NHST.R"
)

tests_post_hoc_path <- here(
  "03_analysis",
  "02_main-analyses",
  "99_run-all",
  "03_run_post-hoc.R"
)

tests_planned_Bayes_path <- here(
  "03_analysis",
  "02_main-analyses",
  "99_run-all",
  "04_run_planned_Bayes.R"
)

tests_multiple_experiment_post_hoc_path <- here(
  "03_analysis",
  "02_main-analyses",
  "99_run-all",
  "05_run_multiple-experiment-post-hoc.R"
)