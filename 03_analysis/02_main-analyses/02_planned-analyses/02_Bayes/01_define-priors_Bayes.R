# Define priors for Bayesian analyses
#
# This is necessary for calculating Bayes factors as you must
# have (preferably informative) priors on parameters of interest.

# Training ----

# define terms which should have an informative prior
# this is then vectorised in the prior definition
if (experiment == 0) {
  informative_prior_terms_training <- c(
    "picture_condition1",
    "language_variety1",
    "picture_condition1:language_variety1",
    "picture_conditionno_picture:language_varietydialect:dialect_words1",
    "picture_conditionpicture:language_varietydialect:dialect_words1",
    "picture_conditionno_picture:language_varietystandard:dialect_words1",
    "picture_conditionpicture:language_varietystandard:dialect_words1"
  )
} else if (experiment %in% c(1, 2)) {
  informative_prior_terms_training <- c(
    "task1",
    "picture_condition1",
    "language_variety1",
    "task1:picture_condition1",
    "task1:language_variety1",
    "picture_condition1:language_variety1",
    "task1:picture_condition1:language_variety1",
    "taskR:picture_conditionno_picture:language_varietydialect:dialect_words1",
    "taskW:picture_conditionno_picture:language_varietydialect:dialect_words1",
    "taskR:picture_conditionpicture:language_varietydialect:dialect_words1",
    "taskW:picture_conditionpicture:language_varietydialect:dialect_words1",
    "taskR:picture_conditionno_picture:language_varietystandard:dialect_words1",
    "taskW:picture_conditionno_picture:language_varietystandard:dialect_words1",  
    "taskR:picture_conditionpicture:language_varietystandard:dialect_words1",
    "taskW:picture_conditionpicture:language_varietystandard:dialect_words1"
  )
} else if (experiment == 3) {
  informative_prior_terms_training <- c(
    "task1",
    "language_variety1",
    "task1:language_variety1",
    "taskR:language_varietydialect:dialect_words1", 
    "taskW:language_varietydialect:dialect_words1", 
    "taskR:language_varietystandard:dialect_words1", 
    "taskW:language_varietystandard:dialect_words1"
  )
}

training_priors <- c(
  # default priors at time of execution:
  set_prior("student_t(3, 0, 10)", class = "sd"),
  set_prior("student_t(3, 0, 10)", class = "sigma"),
  
  # user-defined priors:
  
  # generic weakly informative prior
  set_prior("normal(0, 1)", class = "Intercept"),
  
  # LKJ(2) used to reduce plausibility of perfect correlations
  set_prior("lkj_corr_cholesky(2)", class = "L"),
  
  # wide, very weakly informative priors on all time terms
  # and factors they interact with
  set_prior("normal(0, 10)", class = "b"),
  
  # informative prior: small effects centred on 0, with 95% prob between -.4/.4
  # on all parameters (expect time terms) that do not interact with time terms
  set_prior(
    "normal(0, 0.2)", 
    class = "b", 
    coef = informative_prior_terms_training
  )
)

# Testing ----

# Same priors used for the the main model and the novel words only model.

testing_priors <- c(
  # default priors at time of execution:
  set_prior("student_t(3, 0, 10)", class = "sd"),
  set_prior("student_t(3, 0, 10)", class = "sigma"),
  
  # user-defined priors:
  
  # generic weakly informative prior
  set_prior("normal(0, 1)", class = "Intercept"), 
  
  # LKJ(2) used to reduce plausibility of perfect correlations
  set_prior("lkj_corr_cholesky(2)", class = "L"),
  
  # informative prior: small effects centred on 0, with 95% prob between -.4/.4
  # this is defined for all parameter estimates
  set_prior("normal(0, .2)", class = "b") 
)