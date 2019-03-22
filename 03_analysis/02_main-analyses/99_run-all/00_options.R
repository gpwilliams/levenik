# Define Options ----

# Defines options for fitting models, for example:

# - which dependent variables are used
# - how degrees of freedom are calculated
# - iterations for brms models

# Test Options ----

# emmeans options:
# larger than default limit (complex models) 
# faster computation of df; same as lmerTest
emm_options(lmerTest.limit = 1e5) 
emm_options(lmer.df = "satterthwaite") 

# brms options
iterations <- 2000
cores <- parallel::detectCores() # 6 on my machine
maximum_treedepth <- 10 # default treedepth

# Define Dependent Variable for All Analyses ----

# dependent variable column ID for all analyses (excluding aggregate)
dv <- "lenient_nLED"

# transformed dependent variable column ID 
# (always asin from the make_asinsqrt() function)
dv_transformed <- "asin"

# define transformed and scaled DV
# WARNING: if you change this here, it must also change in all scripts 
dv_transformed_scaled <- "asin_scaled"