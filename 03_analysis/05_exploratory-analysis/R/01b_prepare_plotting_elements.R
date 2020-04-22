# plotting aesthetics ----

# individual plots ----
axis_y_size <- 20
axis_x_size <- 17
n_text_size <- 6

custom_theme <- theme_bw() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    strip.background = element_blank(),
    panel.border = element_rect(colour = "black"),
    axis.title = element_text(size = axis_y_size),
    axis.text.y = element_text(size = axis_y_size),
    axis.text.x = element_text(size = axis_x_size),
    strip.text = element_text(size = axis_y_size),
    legend.title = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 14)
  )

shared_manual_scale <- c("white", "grey80", "grey55", "grey30", "black")

# combined plots ----

shared_theme <- custom_theme +
  theme(
    legend.position = "none",
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    plot.caption = element_blank(),
    axis.title = element_text(size = axis_y_size/1.5),
    axis.text.y = element_text(size = axis_y_size/1.5),
    axis.text.x = element_text(size = axis_x_size/1.8),
    strip.text = element_text(size = axis_y_size/1.5),
  )

# both ----

shared_x_axis_label <- "Word Type"
grand_prop_y_axis_label <- "Proportion of Responses by Response Type"
prop_y_axis_label <- "Mean Proportion of Responses by Response Type"
errorbar_caption <- paste(
  "Error bars represent 1 standard error of the mean.",
  "Error bars omitted for means of tied proportions."
)