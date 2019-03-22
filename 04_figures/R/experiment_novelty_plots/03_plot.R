# testing ----

violin_dotplot <- 
  ggplot(data = by_subj, aes(x = test_words, y = m, fill = test_words)) + 
  geom_flat_violin(scale = "count", trim = TRUE) +
  geom_dotplot(
    binaxis = "y",
    dotsize = test_point_size,
    stackdir = "down",
    binwidth = 0.01,
    inherit.aes = TRUE,
    position = position_nudge(x = -0.025, y = 0)
  ) + 
  geom_pointrange(
    data = summary_data, 
    aes(
      x = test_words, 
      y = means, 
      ymin = means - sds * Err, 
      ymax = means + sds * Err,
      colour = test_words
    ),
    size = test_pointrange_size,
    position = position_nudge(x = 0.05, y = 0)
  ) +
  scale_colour_manual(values = c("white", "black")) +
  scale_fill_grey() +
  scale_y_continuous(breaks = seq(0, 1, by = 0.2)) +
  labs(
    x = "Word Familiarity", 
    y = "Mean Normalised Levenshtein Edit Distance"
  ) +
  geom_text(
    data = summary_data %>% filter(test_words == "Untrained"),
    aes(x = n_label_x_pos, y = n_label_y_pos, label = paste("n = ", N)),
    colour = "black",
    size = n_text_size
  ) +
  guides(fill = FALSE, colour = FALSE) +
  coord_cartesian(ylim = c(0, 1)) +
  custom_theme +
  facet_wrap(~experiment)

ggsave(
  here(
    "04_figures",
    "output",
    "experiments-1-to-2_word-novelty.png"
    ),
  violin_dotplot,
  height = 8, 
  width = 12
)