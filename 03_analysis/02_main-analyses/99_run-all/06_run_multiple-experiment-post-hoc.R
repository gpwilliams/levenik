# Run Multi-Experiment Post-hocs ----

# loads and organised data prior to proper preparation for comparing
# the first three experiments against one another

orthography <- c("transparent", "opaque")

experiment <- 0
source(here("03_analysis", "02_main-analyses", "99_run-all", "01d_analysis_source_file_paths.R"))
source(here("03_analysis", "02_main-analyses", "99_run-all", "01e_output_paths.R"))
load(ex_zero_data)

ex0_data <- data %>% 
  mutate(task_trial_id = session_trial_id) %>%
  select(trial_id:section_trial_id, task_trial_id, everything()) %>% 
  mutate(experiment = "ex0")

# side effect of leaving experiment as 1 after this point:
# for the prepared data, task is (correctly) centred for all experiments
experiment <- 1 
source(here("03_analysis", "02_main-analyses", "99_run-all", "01d_analysis_source_file_paths.R"))
source(here("03_analysis", "02_main-analyses", "99_run-all", "01e_output_paths.R"))
load(ex_one_two_data)

ex1_2_data <- data %>% 
  mutate(experiment = case_when(
    orthography_condition == "transparent" ~ "ex1",
    orthography_condition == "opaque" ~ "ex2"
  ))

data <- rbind(ex0_data, ex1_2_data)

# prepare merged data for analysis
prepare_data(where = data_preparation_source_files)

# run analysis
source_files(multiple_experiment_post_hoc_source_files)

# save post-hocs
saveRDS(
  multiple_experiment_post_hoc_comparisons, 
  file = multiple_experiment_post_hoc_output_path
)