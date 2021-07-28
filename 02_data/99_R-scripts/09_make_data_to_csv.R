# makes all the saved RData files into csv files ----

# folder <- "01_study-zero" # TEMP
# experiments <- "ex_0" # TEMP

# load cleaned data only (only data used for analysis)
data_type <- c("cleaned", "filtered", "filtered_subsetted")

for(i in seq_along(data_type)) {
  this_filename <- paste0("_", data_type[i])
  
  this_file <- paste0(experiments, this_filename)
  load(paste0("../", folder, "/03_cleaned-data/", paste0(this_file, ".Rdata")))
  
  # fix data (get rid of grouping)
  data <- ungroup(data)
  
  # write full data to file in the same folder
  write_csv(
    data, 
    paste0(
      "../", 
      folder, 
      "/03_cleaned-data/", 
      paste0(this_file, "_data.csv")
    )
  )
  
  # write demographic data to file in the same folder
  write_csv(
    demo_data, 
    paste0(
      "../", 
      folder, 
      "/03_cleaned-data/", 
      paste0(this_file, "_demographics_data.csv")
    )
  )
}
