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