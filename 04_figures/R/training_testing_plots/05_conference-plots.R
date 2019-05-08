# make new plots ----

# load libraries
library(tidyverse)
library(here)

# load functions
source(here("04_figures", "functions", "normalise_within_subjects_error.R"))
source(here("04_figures", "functions", "geom_flat_violin.R"))

# define experiments
experiment <- 3
this_task <- "Reading"

# load data ----

if (experiment == 0) {
  # reset tasks to just reading if Experiment 0 (reading only)
  task <- "Reading"
  
  load(
    here(
      "02_data", 
      "01_study-zero", 
      "03_cleaned-data", 
      "ex_0_filtered.RData"
    )
  )
} else if (experiment %in% c(1, 2)) {
  load(
    here(
      "02_data", 
      "02_study-one-and-two", 
      "03_cleaned-data", 
      "ex_1_2_filtered.RData"
    )
  )
  
} else {
  load(
    here(
      "02_data", 
      "03_study-three", 
      "03_cleaned-data", 
      "ex_3_filtered.RData"
    )
  )
}

# subset data for experiments 1 and 2
if (experiment == 1) {
  data <- data %>% filter(orthography_condition == "transparent")
} else if (experiment == 2) {
  data <- data %>% filter(orthography_condition == "opaque")
} else {
  # do nothing
}

# prepare data ----

# run files
source(here("04_figures", "R", "training_testing_plots", "01_prepare-data.R"))

source(here(
  "04_figures", 
  "R", 
  "training_testing_plots", 
  "02_plotting-variables.R"
))

# subset data to the defined task and testing phase
by_subj <- by_subj %>% filter(task == this_task)
by_subj$interacting_factors <- factor(by_subj$interacting_factors)
summary_data <- summary_data %>% filter(task == this_task)
summary_data$interacting_factors <- factor(summary_data$interacting_factors)
ann_text$interacting_factors <- factor(ann_text$interacting_factors)

# define level names (optional); must vary by experiment
new_labels <- c("No Dialect", "Dialect")

levels(by_subj$interacting_factors) <- new_labels
levels(summary_data$interacting_factors) <- new_labels
levels(ann_text$interacting_factors) <- new_labels
  
# training plot ----

line_dotplot <- 
  ggplot() +
  facet_wrap(~ interacting_factors) +
  geom_point(
    data = by_subj %>% filter(block != "Test"),
    aes(x = block, y = m, colour = dialect_words, fill = dialect_words),
    position = position_dodge(dodge_size),
    alpha = point_alpha,
    size = bg_point_size
  ) +
  geom_line(
    data = summary_data %>% filter(block != "Test"),
    aes(x = block, y = means, group = dialect_words, colour = dialect_words),
    position = position_dodge(dodge_size),
    size = linesize
  ) +
  geom_point(
    data = summary_data %>% filter(block != "Test"),
    aes(x = block, y = means, colour = dialect_words),
    position = position_dodge(dodge_size),
    size = summary_point_size
  ) +
  geom_errorbar(
    data = summary_data %>% filter(block != "Test"),
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
      "_conference.png"
    )
  ),
  line_dotplot,
  height = 8, 
  width = 12
)

# testing plot ----

violin_dotplot <- 
  ggplot() + 
  facet_wrap(~ interacting_factors) +
  geom_flat_violin(
    data = by_subj %>% filter(block == "Test"),
    aes(x = dialect_words, y = m, fill = dialect_words),
    scale = "count", 
    trim = TRUE
  ) +
  geom_dotplot(
    data = by_subj %>% filter(block == "Test"),
    aes(x = dialect_words, y = m, fill = dialect_words),
    binaxis = "y",
    dotsize = test_point_size,
    stackdir = "down",
    binwidth = 0.01,
    position = position_nudge(x = -0.025, y = 0)
  ) +
  geom_pointrange(
    data = summary_data %>% filter(block == "Test"), 
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
  labs(x = "Word Type", y = "Reading Inaccuracy (Edit Distance to Target)") + # Mean Normalised Levenshtein Edit Distance
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
      "_conference.png"
    )
  ),
  violin_dotplot,
  height = 8, 
  width = 12
)