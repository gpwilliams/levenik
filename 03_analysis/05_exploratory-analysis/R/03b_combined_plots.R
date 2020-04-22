# combine plots ----
# save all plots together in a panel after having removed the caption

# grand proportion plots ----

# define axis titles across plots
shared_x_axis_label_grob <- textGrob(
  shared_x_axis_label, 
  gp = gpar(fontsize = 15, fontface = "bold")
)
shared_grand_prop_y_axis_label_grob <- textGrob(
  grand_prop_y_axis_label, 
  gp = gpar(fontsize = 15, fontface = "bold"),
  rot = 90
)

# arrange plots
grand_prop_plots <- plot_grid(
  plots_out$ex_0$grand_prop + shared_theme,
  plots_out$ex_1$grand_prop + shared_theme,
  plots_out$ex_2$grand_prop + shared_theme,
  plots_out$ex_3$grand_prop + shared_theme,
  ncol = 2,
  nrow = 2,
  labels = c("A", "B", "C", "D")
)

combined_grand_prop_plots <- arrangeGrob(
  grand_prop_plots, 
  left = shared_grand_prop_y_axis_label_grob,
  bottom = shared_x_axis_label_grob
)

# proportions plots ----

# define shared labels across plots
shared_legend <- get_legend(plots_out$ex_0$prop)
shared_prop_y_axis_label_grob <- textGrob(
  prop_y_axis_label, 
  gp = gpar(fontsize = 15, fontface = "bold"), 
  rot = 90
)

# arrange plots
prop_plots <- plot_grid(
  plots_out$ex_0$prop + shared_theme,
  plots_out$ex_1$prop + shared_theme,
  plots_out$ex_2$prop + shared_theme,
  plots_out$ex_3$prop + shared_theme,
  ncol = 2,
  nrow = 2,
  labels = c("A", "B", "C", "D")
)

# add shared legend to plots
prop_plots2 <- plot_grid(
  shared_legend, 
  prop_plots, 
  ncol = 1, 
  rel_heights = c(.05, 1) # make legend height smaller
)

# give common axis titles (view with grid.arrange()) and caption
combined_prop_plots <- add_sub(
  arrangeGrob(
    prop_plots2, 
    left = shared_prop_y_axis_label_grob, 
    bottom = shared_x_axis_label_grob
    ), 
  errorbar_caption, 
  x = 0, 
  y = 0, 
  hjust = -.02, 
  vjust = -.5
)

# save plots ----

ggsave(
  filename = here(
    "03_analysis", 
    "05_exploratory-analysis", 
    "output",
    "plots",
    "combined_grand_mean_proportions.png"
  ),
  plot = combined_grand_prop_plots,
  height = 14, width = 12
)

ggsave(
  filename = here(
    "03_analysis", 
    "05_exploratory-analysis", 
    "output",
    "plots",
    "combined_mean_proportions.png"
  ),
  plot = combined_prop_plots,
  height = 14, width = 12
)