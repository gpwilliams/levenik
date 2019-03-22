# Define Paths ----

# Output Paths ----

# used as output paths in individual files of the run_all folder

demographics_output_path <- here(
  "03_analysis",
  "02_main-analyses",
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
  "02_main-analyses",
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
  "02_main-analyses",
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
  "02_main-analyses",
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
  "02_main-analyses",
  "04_output",
  paste0(
    "0",
    experiment + 1,
    "_experiment-",
    experiment
  ),
  "planned-comparisons_Bayes.RData"
)

multiple_experiment_post_hoc_output_path <- here(
  "03_analysis",
  "02_main-analyses",
  "04_output",
  "05_multiple-experiments",
  "multiple-experiment_post-hoc-comparisons.RData"
)

session_info_output_path <- here(
  "03_analysis",
  "02_main-analyses",
  "04_output",
  "session_info.RData"
)

# Paths for compressed results ----

compressed_results_path <- here(
  "03_analysis",
  "02_main-analyses",
  "04_output",
  "06_all-results_compressed",
  "all-results_compressed.RData"
)