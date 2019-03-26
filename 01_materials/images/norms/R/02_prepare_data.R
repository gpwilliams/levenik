# prepare data and output in one table ----

# list files from rossion and pourtois path ----

rp_files <- list.files(
  path = rp_path,
  pattern = "*.csv",
  full.names = TRUE
)

# load data ----

rp_data <- map(
  rp_files,
  read_csv, 
  col_names = TRUE
)

item_subset <- read_csv(sub_path)

# clean data ----

# rossion and pourtois ----
rp_data[2:4] <- rp_data[2:4] %>%
  map(~ .x %>%
    separate(
      id,
      into = c("item_number", "concept"),
      sep = ". ",
      extra = "merge" # handles spaces in names
    ) %>%
    mutate(
      item_number = as.numeric(item_number)
    ))

# remove spaces in all concept names
rp_data <- rp_data %>% 
  map(~ .x %>% 
    mutate(concept = str_replace_all(concept, " ", "-"))
  ) 

# give item numbers to first table
rp_data[[1]] <- left_join(
  rp_data[[1]] %>% 
    mutate(concept = case_when(
      concept == "accordeon" ~ "accordion", # fix spelling error
      TRUE ~ as.character(concept))
    ), 
  rp_data[[2]] %>% select(item_number, concept),
  by = "concept"
)

# reorder variables in 1
rp_data[[1]] <- rp_data[[1]] %>% select(item_number, concept, rating)

# assign names to data
names(rp_data) <- list.files(
  path = rp_path,
  pattern = "*.csv",
  full.names = FALSE
) %>% str_replace_all(., ".csv", "")

# drop french names from naming ratings
rp_data[[5]] <- rp_data[[5]] %>% select(-french_concept)

# subset data ----

item_subset <- item_subset %>%
    separate(
      id,
      into = c("item_number", "concept"),
      sep = ". ",
      extra = "merge" # handles spaces in names
    ) %>%
    mutate(
      item_number = as.numeric(item_number)
    )

# create data subsets ----

rp_subset <- rp_data %>%
  map(~ .x %>% semi_join(., item_subset, by = c("item_number", "concept")))

# save lists as RData files
saveRDS(
  rp_data, 
  file = rp_output_path
)

saveRDS(
  rp_subset, 
  file = rp_subset_output_path
)