# libraries and packages ----
library(here)
library(tidyverse)

source(here("01_materials", "images", "norms", "R", "01_file_paths.R"))
source(here("01_materials", "images", "norms", "R", "02_prepare_data.R"))
source(here("01_materials", "images", "norms", "R", "03_analysis.R"))

rmarkdown::render(
  here("01_materials", "images", "norms", "R", "04_report.Rmd"),
  "pdf_document",
  output_file = here(
    "01_materials", 
    "images", 
    "norms", 
    "docs", 
    "picture_norms_report.pdf"
  )
)