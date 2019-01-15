# data checks: plots ----
# plots individual performance for review

# define custom plotting elements for this set of plots
add_custom_plot_elements <- function(ggplot_object, y_heading, y_subheading) {
  ggplot_object +
    # highlight poor performers
    geom_rect(
      data = subset(sub_data, !is.na(reason_for_dropping)),
      xmin = -Inf,
      xmax = Inf,
      ymin = -Inf,
      ymax = Inf,
      fill = "red",
      alpha = 0.01
    ) +
    geom_vline(
      xintercept = c(
        plotting_details$minimum - 0.5,
        max(plotting_details$maximum) + 0.5
      ),
      alpha = 0.3,
      linetype = 2
    ) +
    geom_text(
      data = text_headings,
      aes(x = text_loc, y = y_heading, label = text),
      fontface = 3,
      size = 3,
      colour = "black"
    ) +
    geom_text(
      data = text_subheadings,
      aes(x = text_loc, y = y_subheading, label = text),
      fontface = 3,
      size = 2,
      colour = "black"
    ) +
    scale_x_continuous(
      limits = c(
        min(plotting_details$minimum) - 0.5,
        max(plotting_details$maximum) + 0.5
      ),
      breaks = c(
        plotting_details$minimum,
        max(plotting_details$maximum)
      )
    ) +
    labs(x = "Trial Number") +
    theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )
}

# Load data ----

load(paste0(
  "../",
  folder,
  "/03_cleaned-data/",
  experiments,
  "_filtered.Rdata"
))

dropped_participants <- read.csv(
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_dropped_participants_and_reasons.csv"
  ),
  stringsAsFactors = F
)

# filter to reading only (for direct comparison between ex0 and ex1, 2, and 3)
data <- filter(data, task == "R")

# transform data ----

# define trial identifier (count by task if multiple tasks)
if (experiments == "ex_0") {
  trial_id <- quo(session_trial_id)
} else {
  trial_id <- quo(task_trial_id)
}

# subset performance checks to poor performers
check_performance <- dropped_participants %>%
  filter(group == "performance") %>%
  rename(reason_for_dropping = group) %>%
  select(participant_number, reason_for_dropping)

# calculate those with missing trials
missing_trials <- data %>%
  group_by(participant_number) %>%
  summarise(total_trials = max(!!!trial_id)) %>%
  filter(total_trials != max(total_trials))

# add target distance column
data <- data %>%
  mutate(
    target = as.character(target),
    primary_coder_response = as.character(primary_coder_response),
    target_distance = nchar(target) - nchar(primary_coder_response),
    target_distance = abs(target_distance)
  )

# merge with poor performers to highlight on plot with red fill
data <- full_join(data, check_performance, by = "participant_number")

# define plotting features ----

# get min, max, and midpoints for plotting vlines/annotations
plotting_details <- data %>%
  filter(participant_number %!in% missing_trials$participant_number) %>%
  group_by(block) %>%
  summarise(
    minimum = min(!!!trial_id),
    maximum = max(!!!trial_id),
    text_loc = mean(c(minimum, maximum))
  ) %>%
  mutate(text = c(rep(2:length(levels(data$block)) - 1), "Test"))

text_headings <- data.frame(
  text = c("Training", "Testing"),
  text_loc = c(
    mean(plotting_details$text_loc[plotting_details$block != "TEST"]),
    plotting_details$text_loc[plotting_details$block == "TEST"]
  )
)

text_subheadings <- plotting_details %>%
  filter(block != "TEST") %>%
  select(text, text_loc)

# target distance plot ----

# for both plots, we only do reading (for direct comparison to ex0)
for (i in seq_along(levels(data$orthography_condition))) {
  # define data and titles for each experiment
  if (experiments == "ex_0" & i == 1) {
    sub_data <- data
    file_heading <- "ex-0"
    experiment_title <-
      "Experiment 0: Reading only with an Opaque Orthography."
  } else if (experiments == "ex_1_2" & i == 1) {
    sub_data <- data %>% filter(orthography_condition == "transparent")
    file_heading <- "ex-1"
    experiment_title <-
      paste0(
        "Experiment 1: Reading and Writing with a Transparent Orthography.",
        "\n Data based on Reading Performance Only."
        )
  } else if (experiments == "ex_1_2" & i == 2) {
    sub_data <- data %>% filter(orthography_condition == "opaque")
    file_heading <- "ex-2"
    experiment_title <-
      paste0(
        "Experiment 2: Reading and Writing with an Opaque Orthography.",
        "\n Data based on Reading Performance Only."
      )
  } else if(experiments == "ex_3") {
    sub_data <- data %>% filter(orthography_condition == "opaque")
    file_heading <- "ex-3"
    experiment_title <-
      paste0(
        "Experiment 3: Reading and Writing with an Opaque Orthography.",
        "\n Data based on Reading Performance Only."
      )
  } else {
    message("something went wrong during plotting - see file 07.")
  }

  # calculate number of pages to print
  n_cols <- 3
  n_rows <- 5
  n_pages <- ceiling(length(unique(sub_data$participant_number)) / 
                       (n_cols * n_rows))

  # define pdf name
  print(paste("making plots for", file_heading))
  pdf(
    paste0(
      "../",
      folder,
      "/05_data-checks/",
      file_heading,
      "_target-distances.pdf"
    ),
    paper = "a4"
  )
  # run plotting
  for (j in seq_len(n_pages)) {
    print(
      add_custom_plot_elements(
        ggplot(sub_data, aes(x = section_trial_id, y = target_distance)) +
          geom_bar(stat = "identity", position = "dodge") +
          facet_wrap_paginate(
            ~participant_number,
            ncol = n_cols,
            nrow = n_rows,
            page = j
          ) +
          labs(y = "Absolute Target Distance (Number of Letters)") +
          ggtitle(
            paste(
              experiment_title,
              "\nDistance (i.e. number of letters) from the target to the",
              "\n participant's input on each trial split by participant."
            )
          ),
        max(sub_data$target_distance, na.rm = T) - 0.2,
        max(sub_data$target_distance, na.rm = T) - 0.6
      )
    )
  }
  dev.off()
}

# overall performance ----

# define orthographies in the data set
orthography_levels <- levels(data$orthography_condition)

for (i in seq_along(orthography_levels)) {
  orth <- orthography_levels[i]
  # define data and titles for each experiment
  if (experiments == "ex_0") {
    file_heading <- "ex-0"
    sub_data <- data
    experiment_title <-
      "Experiment 0: Reading only with an Opaque Orthography."
  } else if (experiments == "ex_1_2" & orth == "transparent") {
    sub_data <- data %>% filter(orthography_condition == "transparent")
    file_heading <- "ex-1"
    experiment_title <-
      paste0(
        "Experiment 1: Reading and Writing with a Transparent Orthography.",
        "\n Data based on Reading Performance Only."
      )
  } else if (experiments == "ex_1_2" & orth == "opaque") {
    sub_data <- data %>% filter(orthography_condition == "opaque")
    file_heading <- "ex-2"
    experiment_title <-
      paste0(
        "Experiment 2: Reading and Writing with an Opaque Orthography.",
        "\n Data based on Reading Performance Only."
      )
  } else if(experiments == "ex_3") {
    sub_data <- data %>% filter(orthography_condition == "opaque")
    file_heading <- "ex-3"
    experiment_title <-
      paste0(
        "Experiment 3: Reading and Writing with an Opaque Orthography.",
        "\n Data based on Reading Performance Only."
      )
  } else {
    message("something went wrong during plotting - see file 07.")
  }
  
  # calculate number of pages to print
  n_cols <- 3
  n_rows <- 5
  n_pages <- ceiling(length(unique(sub_data$participant_number)) / 
                       (n_cols * n_rows))
  
  pdf(
    paste0(
      "../",
      folder,
      "/05_data-checks/",
      file_heading,
      "_lenient_nLED.pdf"
    ),
    paper = "a4"
  )
  # run plotting
  for (j in seq_len(n_pages)) {
    print(
      add_custom_plot_elements(
        ggplot(sub_data, aes(x = !!trial_id, y = lenient_nLED)) +
          geom_line() +
          geom_point() +
          facet_wrap_paginate(
            ~participant_number,
            ncol = n_cols,
            nrow = n_rows,
            page = j
          ) +
          labs(y = "Lenient normalised Levenshtein Edit Distance (nLED)") +
          ggtitle(
            paste(
              experiment_title,
              "\nLenient normalised Levenshtein Edit Distance (nLED)",
              "\n on each trial split by participant."
            )
          ),
        0.9,
        0.8
      )
    )
  }
  dev.off()
}