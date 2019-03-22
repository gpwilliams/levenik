# make new plots ----

# load libraries
library(tidyverse)
library(here)

# load functions
source(here("04_figures", "functions", "normalise_within_subjects_error.R"))
source(here("04_figures", "functions", "geom_flat_violin.R"))

# make word novelty plots for experiments 0-2
source(here(
  "04_figures",
  "R_code",
  "experiment_novelty_plots",
  "01_prepare-data.R"
))

source(here(
  "04_figures",
  "R_code", 
  "experiment_novelty_plots", 
  "02_plotting-variables.R"
))

source(here(
  "04_figures", 
  "R_code", 
  "experiment_novelty_plots", 
  "03_plot.R"
))