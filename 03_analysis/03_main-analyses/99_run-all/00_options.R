# Define Options ----

# Defines options for fitting models, for example:

# - which dependent variables are used
# - how degrees of freedom are calculated
# - number of iterations used for model fitting

# Test Options ----

# emmeans options:
# larger than default limit (complex models) 
# faster computation of df; same as lmerTest
emm_options(lmerTest.limit = 1e5) 
emm_options(lmer.df = "satterthwaite") 

# Define Dependent Variable for All Analyses ----

# dependent variable column ID for all analyses (excluding aggregate)
dv <- "lenient_nLED"

# dependent variable column ID for aggregated analyses
# WARNING: if you change this here, it must also change in all scripts
agg_dv <- "mean_nLED" 

# transformed dependent variable column ID 
# (always asin from the make_asinsqrt() function)
dv_transformed <- "asin"

# establish random factors for all models in all Bayesian analyses
random_factors_bf <- c("participant_number", "target")

# define number of iterations for Bayesian tests
iterations <- 5e5 # 500k