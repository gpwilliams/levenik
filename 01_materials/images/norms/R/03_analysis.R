# load data ----

f_data <- read_csv(f_path)
w_data <- read_csv(w_path)
rp_data <- readRDS(rp_subset_output_path)

# subset to colour items only
rp_data[2:5] <- rp_data[2:5] %>%
  map(~ .x %>% select(item_number, concept, contains("color")))

# create summaries ----

# our compression ----

w_data %>% summarise(GIF_mean = mean(GIF), GIF_sd = sd(GIF))

# forsythe et al ----

f_data %>% 
  summarise_at(
    vars(familiarity:GIF),
    list(mean = mean, sd = sd), 
    na.rm = TRUE
  )

# rossion and pourtois ----

# colour diagnosticity
colour_ratings <- rp_data[[1]] %>% 
  summarise(mean = mean(rating), sd = sd(rating)) %>%
  mutate(rating = "colour_diagnosticity")

# complexity, familiarity, imagery
cfi_ratings <- rp_data[2:4] %>% map(
  ~ .x %>%
    summarise(
      mean = mean(mean_color), sd = sd(mean_color)
    )
) %>%
  bind_rows(.id = "rating")

# naming
name_ratings <- rp_data[[5]] %>%
  summarise_at(
    vars(contains("color")),
    list(mean = mean, sd = sd)
  ) %>%
  gather(key = "rating") %>%
  mutate(
    rating_type = case_when(
      str_detect(rating, "mean") ~ "mean",
      str_detect(rating, "sd") ~ "sd")
  ) %>%
  mutate(rating = str_replace_all(rating, c("_mean" = "", "_sd" = ""))) %>%
  spread(rating_type, value)

# join together into one summary table
all_ratings <- bind_rows(
  name_ratings,
  cfi_ratings,
  colour_ratings
)

write_csv(all_ratings, all_ratings_output_path)