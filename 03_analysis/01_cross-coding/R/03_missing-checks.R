# Missing input checks ----

# Check submissions with no clearly identifiable or missing input
# this is used purely for manual data checks to be sure that each
# item is coded correctly.

# extract all data with x, *, ?, or NA
data_checks <- data_subset %>%
  filter(
    primary_coder_response == "?" |
    secondary_coder_response == "?" |
    primary_coder_response == "x" |
    secondary_coder_response == "x" |
    primary_coder_response == "*" |
    secondary_coder_response == "*" |
    is.na(primary_coder_response) |
    is.na(secondary_coder_response)
  )

missing_submissions_file_name <- paste0(
  "experiment_", 
  experiment, 
  "_missing-submissions.csv"
)

# save outputs
write.csv(
  data_checks,
  file = here(
    "03_analysis", 
    "01_cross-coding", 
    "output",
    "missing_results",
    missing_submissions_file_name
  )
)