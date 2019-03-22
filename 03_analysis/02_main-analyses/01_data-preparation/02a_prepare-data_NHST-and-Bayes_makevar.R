# Data Preparation for NHST & Bayesian Analyses ----

# Makes new variables for analysis

# Make New Variables ----

# convert block to numeric for calculating orthogonal polynomials of block
# make participant number and target a factor for lme4 and Bayes factor
# random effects
data <- data %>%
  mutate(
    block_num = as.numeric(block),
    target = as.factor(target),
    participant_number = as.factor(participant_number)
  ) %>%
  filter(!is.na(!!sym(dv))) %>% # filter out NA; analyses fail when present
  make_asinsqrt(., dv)