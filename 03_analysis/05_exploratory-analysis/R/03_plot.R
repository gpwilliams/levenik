# TODO

# numbers in column counts need to be bigger and higher contras

# plotting aesthetics ----

# shared
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

# plots ----

grand_prop_plot <- ggplot(
  data_summaries$grand_proportions %>% 
    mutate(interacting_factors = interaction(task, language_variety, sep = ": ")),
  aes(x = dialect_words, y = proportion, fill = lenient_coder_error_types)
  ) +
  facet_wrap(interacting_factors ~.) +
  geom_bar(stat = "identity", position = "stack") +
  scale_y_continuous(breaks = seq(0, 1, by = 0.2)) +
  labs(x = "Word Type", y = "Proportion of Responses by Response Type") +
  scale_fill_brewer(palette = "Accent") +
  custom_theme


# plot the average proportion of dialect errors vs. other errors
prop_plot <- ggplot(
  data_summaries$mean_proportions %>% 
    mutate(interacting_factors = interaction(task, language_variety, sep = ": ")), 
  aes(x = dialect_words, y = mean_prop, fill = lenient_coder_error_types)
) +
  facet_wrap(interacting_factors ~.) +
  geom_bar(stat = "identity", position = "dodge", width = 0.9) +
  geom_errorbar(
    aes(ymin = mean_prop - se_prop, ymax = mean_prop + se_prop), 
    position = position_dodge(width = 0.9), 
    width = 0.25
  ) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.2)) +
  coord_cartesian(ylim = c(0, 1)) +
  labs(x = "Word Type", y = "Mean Proportion of Responses by Response Type") +
  scale_fill_brewer(palette = "Accent") +
  custom_theme +
  labs(caption = "Error bars represent 1 standard error of the mean") +
  theme(plot.caption = element_text(size = 14))

ggsave(
  filename = here(
    "03_analysis", 
    "05_exploratory-analysis", 
    "output",
    "plots",
    paste0("experiment_", experiment, "_grand-proportions-responses.png")
  ),
  plot = grand_prop_plot,
  height = 14, width = 12
)

ggsave(
  filename = here(
    "03_analysis", 
    "05_exploratory-analysis", 
    "output",
    "plots",
    paste0("experiment_", experiment, "_mean-proportions-responses.png")
  ),
  plot = prop_plot,
  height = 14, width = 12
)