# testing ----

violin_dotplot <- 
  ggplot() + 
  facet_wrap(~ interacting_factors) +
  geom_flat_violin(
    data = by_subj %>% filter(task == this_task, block == "Test"),
    aes(x = dialect_words, y = m, fill = dialect_words),
    scale = "count", 
    trim = TRUE
  ) +
  geom_dotplot(
    data = by_subj %>% filter(task == this_task, block == "Test"),
    aes(x = dialect_words, y = m, fill = dialect_words),
    binaxis = "y",
    dotsize = test_point_size,
    stackdir = "down",
    binwidth = 0.01,
    position = position_nudge(x = -0.025, y = 0)
  ) +
  geom_pointrange(
    data = summary_data %>% filter(task == this_task, block == "Test"), 
    aes(
      x = dialect_words, 
      y = means, 
      ymin = means - sds * Err, 
      ymax = means + sds * Err,
      colour = dialect_words
    ),
    size = test_pointrange_size,
    position = position_nudge(x = 0.05, y = 0)
  ) +
  scale_colour_manual(values = c("white", "white", "black")) +
  scale_fill_grey() +
  scale_y_continuous(breaks = seq(0, 1, by = 0.2)) +
  labs(x = "Word Type", y = "Mean Normalised Levenshtein Edit Distance") +
  geom_text(
    data = summary_data %>% 
      filter(
        task == this_task, 
        block == "Test", 
        dialect_words == "Contrastive"
      ),
    aes(x = n_label_x_pos_testing, y = n_label_y_pos, label = paste("n = ", N)),
    colour = "black",
    size = n_text_size
  ) +
  guides(fill = FALSE, colour = FALSE) +
  coord_cartesian(xlim = c(1:3), ylim = c(0, 1)) +
  custom_theme

ggsave(
  here(
    "04_figures",
    "output",
    paste0(
      "experiment-",
      experiment,
      "_testing_plot_",
      tolower(this_task),
      ".png"
    )
  ),
  violin_dotplot,
  height = 8, 
  width = 12
)