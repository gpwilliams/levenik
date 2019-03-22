# Post-hoc comparisons using NHST - Mutli-Experiment Analysis

# compares Experiments 0-2 on Language Variety by Word Novelty

# Testing ---------------------------------------------------------------------

message("Running Post-hoc Comparisons: Mutliple Experiments.")
  
# define formula
experiment_novelty_formula <- as.formula(paste(
  dv_transformed,
  "~ 
  experiment * test_words +
  (1 + (experiment_c_02 + experiment_c_12) | target) +
  (1 + test_words_c | participant_number)"
))

# fit model
lme_experiment_novelty <- lmer(
  experiment_novelty_formula, 
  testing,
  control = lmerControl(optCtrl = list(maxfun = 1e5))
)

# run pairwise tests
test_en_pair <- emmeans(lme_experiment_novelty, c("experiment", "test_words"))