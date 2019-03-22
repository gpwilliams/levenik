# Plotting Variables ----

# offset title depending on experiment
mean_blocks <- c(max_blocks - 1, max_blocks)

# make annotations for condition labels
ann_text <- summary_data %>%
  filter(block != "Test", picture_condition == "Picture") %>%
  mutate(block = as.numeric(block)) %>%
  filter(
    block %in% mean_blocks, 
    language_variety == "Variety Mismatch", 
    task == this_task
  ) %>%
  group_by(
    picture_condition,
    task, 
    language_variety, 
    interacting_factors, 
    dialect_words
  ) %>%
  summarise(m = mean(means)) %>%
  ungroup() %>%
  mutate(
    block = mean(mean_blocks), # get position for label
    m = ifelse(
      dialect_words == "Non-Contrastive",
      m - 0.15, # adjust positions to avoid overplotting
      m + 0.1
    ),
    lab = dialect_words
  )

# make positions for labelling N subjects
n_label_x_pos_testing <- 3.3

if (experiment %in% c(0:2)) {
  n_label_x_pos_training <- max_blocks + .3
  n_label_y_pos <- 0.985
} else {
  n_label_x_pos_training <- max_blocks
  n_label_y_pos <- 1.02
}

# aesthetics ----

# training
dodge_size <- 0.2
bg_point_size <- 2
linesize <- 1.5
summary_point_size <- 4
errorbar_size <- 1.5
textsize <- 6
point_alpha <- 0.3

# testing
test_point_size <- 1
test_pointrange_size <- 0.75

# shared
axis_y_size <- 20
axis_x_size <- 17
n_text_size <- 6

# themes ----

custom_theme <- theme_bw() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    strip.background = element_blank(),
    panel.border = element_rect(colour = "black"),
    axis.title = element_text(size = axis_y_size),
    axis.text.y = element_text(size = axis_y_size),
    axis.text.x = element_text(size = axis_x_size),
    strip.text = element_text(size = axis_y_size)
  )