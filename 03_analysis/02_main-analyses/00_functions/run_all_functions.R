# Functions for use in the Levenik study
# Author: Dr. Glenn P. Williams

# Data Reading Functions ----

# read many files
source_files <- function(path, pattern = "[.]R$") {
  # path = string of path to files (e.g. "01_data-preparation/")
  # pattern = string of file pattern to load, defaults to files ending in .R
  sapply(
    list.files(
      pattern = pattern,
      path = path,
      full.names = TRUE
    ),
    source
  )
}

# prepare data for analyses, loading to global environment
prepare_data <- function(where, skip = FALSE) {
  # where = path to folder containing files to be read
  # skip = logical determining whether or not to read files in path
  #         defaults to FALSE
  if (skip == FALSE) {
    source_files(where)
  } else {
    message("The data are already prepared; skipping preparation.")
  }
}

# read and assign many RData files files to a list
load_files <- function(path, pattern = "[.]R$") {
  # path = string of path to files (e.g. "01_data-preparation/")
  # pattern = string of file pattern to load, defaults to files ending in .R
  sapply(
    list.files(
      pattern = pattern,
      path = path,
      full.names = TRUE
    ),
    source
  )
}