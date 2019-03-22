# inter-rater reliability measures ----

# see: http://www.cookbook-r.com/Statistical_analysis/Inter-rater_reliability/

# Cohen's kappa for categorical data (Fleiss' Kappa for > 2 raters)
kappa_results <- kappa2(
  data_subset %>% select(contains("correct")), 
  "unweighted"
)

# intraclass correlation for nLED; automatically ignores NAs
icc_results <- icc(
  data_subset %>% select(contains("nLED")), 
  model = "twoway", 
  type = "agreement"
)

# store in list
irr_results <- list(
  kappa_results = kappa_results,
  icc_results = icc_results
)

# save results
saveRDS(
  irr_results, 
  file = here(
    "03_analysis", 
    "01_cross-coding", 
    "output",
    "irr_results",
    paste0("experiment_", experiment, "_irr-results", ".RData"))
)