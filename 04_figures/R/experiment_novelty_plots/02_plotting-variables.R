# Plotting Variables ----

# make positions for labelling N subjects
n_label_x_pos <- 2.25
n_label_y_pos <- 1.03

# aesthetics ----

test_point_size <- 1
test_pointrange_size <- 0.75
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