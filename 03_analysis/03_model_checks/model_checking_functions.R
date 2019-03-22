# Model checking functions ----

check_nonconvergence <- function(lmerModLmerTest) {
  # checks for any messages in a saved model object for failure to converge
  # input: (g)lmerMod object (i.e. model from lme4)
  if(class(lmerModLmerTest) == "lmerModLmerTest") {
    any(grepl("failed to converge", lmerModLmerTest@optinfo$conv$lme4$messages))
  } else {
    stop("Object is not of class lmerModLmerTest")
  }
}

check_corr <- function(
  lmerMod, 
  subj_id = "participant_number", 
  item_id = "target", 
  corr_lim = .96, 
  round = TRUE, 
  decimals = 3
) {
  # lmerMod = input lmerMod
  # subj_id = name of random effects ID for subjects (e.g. participant_number)
  # item_id = name of random effects ID for subjects (e.g. target)
  # corr_lim = limit of correlation by which to keep results (defaults to .96)
  #           used for detecting correlations beyond a set cut off
  # round = whether or not to round the correlation parameter
  #         NOTE: regardless of rounding this is returned as the column corr_abs
  #               i.e. the absolute (signless) value of the correlation
  #               so the true correlation parameter remains untouched.
  #               BUT corr_abs is the value at which correlations are 
  #               measured against the cutoff (corr_lim)
  # decimals = rounding used for corr_abs (if requested). Note that this is used
  #             for detecting approximately perfect correlations (i.e. -1/1)
  #             as it is unlikely that a truly perfect correlation to a high number of
  #             decimals will be reported in R.
  lmerMod_attr <- lapply(unclass(VarCorr(lmerMod)), attributes)
  subj_corr <- lmerMod_attr[[subj_id]]$correlation
  item_corr <- lmerMod_attr[[item_id]]$correlation
  
  subj_corr <- subj_corr %>% 
    as.data.frame() %>%
    tibble::rownames_to_column("term") %>%
    gather(key = "term_comparison", value = "corr", -term) %>%
    mutate(corr_mat = "subj")
  
  item_corr <- item_corr %>%
    as.data.frame() %>%
    tibble::rownames_to_column("term") %>%
    gather(key = "term_comparison", value = "corr", -term) %>% 
    mutate(corr_mat = "item")
  
  output <- bind_rows(subj_corr, item_corr) %>%
    mutate(corr_abs = abs(corr)) %>%
    select(corr_mat, everything())
  
  if (round == TRUE) {
    output <- output %>% mutate(corr_abs = round(corr_abs, decimals))
  } else {
    # do nothing
  }
  output %>% 
    filter(term != term_comparison, corr_abs >= corr_lim)
}

rm_emtpy_df_list <- function(list_of_dfs) {
  # removes empty data.frames from a list of data.frames
  keep(list_of_dfs, function(x) nrow(x) > 0)
}

get_excessive_corrs <- function(
  # Gets only excessively high correlations between random effects
  #   and puts these in a data.frame with an ID column by which to identify
  #   the model to be simplified
  # Relies primarily on the check_corr() function
  # lmerMod = input lmerMod
  # subj_id = name of random effects ID for subjects (e.g. participant_number)
  # item_id = name of random effects ID for subjects (e.g. target)
  # corr_lim = limit of correlation by which to keep results (defaults to .96)
  #           used for detecting correlations beyond a set cut off
  # round = whether or not to round the correlation parameter
  #         NOTE: regardless of rounding this is returned as the column corr_abs
  #               i.e. the absolute (signless) value of the correlation
  #               so the true correlation parameter remains untouched.
  #               BUT corr_abs is the value at which correlations are
  #               measured against the cutoff (corr_lim)
  # decimals = rounding used for corr_abs (if requested). Note that this is used
  #             for detecting approximately perfect correlations (i.e. -1/1)
  #             as it is unlikely that a truly perfect correlation to a high number of
  #             decimals will be reported in R.
  list_of_merMods,
  subj_id = "participant_number",
  item_id = "target",
  corr_lim = .96,
  round = TRUE,
  decimals = 3,
  row_id = "model") {
  map(
    list_of_merMods,
    check_corr,
    subj_id = "participant_number",
    item_id = "target",
    corr_lim = corr_lim,
    round = round,
    decimals = decimals
  ) %>% # get execcisvely high correlations between random effects
    rm_emtpy_df_list() %>% # clean up
    bind_rows(., .id = row_id) # used for identifying the model to simplify
}