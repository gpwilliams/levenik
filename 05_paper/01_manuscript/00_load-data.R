# load data for all experiments into the global environment

results <- readRDS(here(
  "03_analysis", 
  "02_main-analyses", 
  "04_output", 
  "06_all-results_compressed", 
  "all-results_compressed.RData"
  ))

# add inter-rater reliability results
experiments <- 0:3

for (i in seq_along(experiments)) {
  experiment <- experiments[i]
  
  # add ICC checks
  irr_path <- here(
    "03_analysis", 
    "01_cross-coding", 
    "output", 
    "irr_results", 
    paste0("experiment_", experiment, "_irr-results.RData")
  )
  results[[i]]$irr_results <- readRDS(irr_path)
}