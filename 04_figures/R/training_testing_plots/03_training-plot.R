# training ----

line_dotplot <- 
  ggplot() +
  facet_wrap(~ interacting_factors) +
  geom_point(
    data = by_subj %>% filter(task == this_task, block != "Test"),
    aes(x = block, y = m, colour = dialect_words, fill = dialect_words),
    position = position_dodge(dodge_size),
    alpha = point_alpha,
    size = bg_point_size
  ) +
  geom_line(
    data = summary_data %>% filter(task == this_task, block != "Test"),
    aes(x = block, y = means, group = dialect_words, colour = dialect_words),
    position = position_dodge(dodge_size),
    size = linesize
  ) +
  geom_point(
    data = summary_data %>% filter(task == this_task, block != "Test"),
    aes(x = block, y = means, colour = dialect_words),
    position = position_dodge(dodge_size),
    size = summary_point_size
  ) +
  geom_errorbar(
    data = summary_data %>% filter(task == this_task, block != "Test"),
    aes(
      x = block,
      ymin = means - (sds * Err),
      ymax = means + (sds * Err),
      colour = dialect_words
    ),
    width = .2,
    position = position_dodge(dodge_size),
    size = errorbar_size
  ) +
  scale_fill_grey(start = 0.2, end = 0.5) +
  scale_colour_grey(start = 0.2, end = 0.5) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.2)) +
  labs(x = "Block", y = "Mean Normalised Levenshtein Edit Distance") +
  guides(fill = FALSE, colour = FALSE) +
  geom_text(
    data = summary_data %>% 
      filter(
        task == this_task, 
        block == max_blocks, 
        dialect_words == "Contrastive"
      ),
    aes(x = n_label_x_pos_training, y = n_label_y_pos, label = paste("n = ", N)),
    colour = "black",
    size = n_text_size
  ) +
  geom_text(
    data = ann_text,
    aes(x = block, y = m, label = lab, colour = dialect_words),
    fontface = "bold",
    size = textsize
  ) +
  coord_cartesian(xlim = c(1:max_blocks), ylim = c(0, 1)) +
  custom_theme

ggsave(
  here(
    "04_figures",
    "output",
    paste0(
      "experiment-",
      experiment,
      "_training_plot_",
      tolower(this_task),
      ".png"
    )
  ),
  line_dotplot,
  height = 8, 
  width = 12
)