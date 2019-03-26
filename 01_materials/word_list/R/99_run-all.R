# libraries and packages ----
library(here)
library(tidyverse)

rmarkdown::render(
  here("01_materials", "word_list", "R", "01_word_ruleset.Rmd"),
  "pdf_document",
  output_file = here(
    "01_materials", 
    "word_list", 
    "docs", 
    "word_ruleset_report.pdf"
  )
)