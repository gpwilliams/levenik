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
    strip.text = element_text(size = axis_y_size)
  )

# plots ----

# plot the average proportion of dialect errors vs. other errors
prop_plot <- ggplot(
  data_summaries$error_averages_by_subj %>% 
    mutate(interacting_factors = interaction(task, language_variety, sep = ": ")), 
  aes(x = dialect_words, y = mean_prop)
) +
  facet_wrap(interacting_factors ~.) +
  geom_bar(stat = "identity") +
  geom_errorbar(
    aes(ymin = mean_prop - se_prop, ymax = mean_prop + se_prop), 
    width = 0.25
  ) +
  scale_y_continuous(breaks = seq(0, 0.2, by = 0.02)) +
  coord_cartesian(ylim = c(0, 0.18)) +
  labs(x = "Word Type", y = "Proportion of Dialect Word Errors vs. All Others") +
  custom_theme

# plot the count of dialect errors 
count_plot <- ggplot(
  data_summaries$error_averages_by_subj %>% 
    mutate(interacting_factors = interaction(task, language_variety, sep = ": ")), 
  aes(x = dialect_words, y = total)
) +
  facet_wrap(task ~ language_variety) +
  geom_bar(stat = "identity") +
  labs(x = "Word Type", y = "Count of Dialect Word Errors") +
  stat_summary(
    fun.y = function(x) {sum(x)/2}, 
    geom = "text", 
    aes(label = paste0(total, "/", n_obs), vjust = 0)
  ) +
  custom_theme

ggsave(
  filename = here(
    "03_analysis", 
    "05_exploratory-analysis", 
    "output",
    "plots",
    paste0("experiment_", experiment, "_proportion-dialect-error.png")
  ),
  plot = prop_plot,
  height = 14, width = 12
)

ggsave(
  filename = here(
    "03_analysis", 
    "05_exploratory-analysis", 
    "output",
    "plots",
    paste0("experiment_", experiment, "_count-dialect-error.png")
  ),
  plot = count_plot,
  height = 14, width = 12
)