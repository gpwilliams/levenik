# Functions for use in the Levenik study
# Author: Dr. Glenn P. Williams

# TODO
# - Improve the lme_by() function.
#     This should probably be changed to group_by(), nest(), map()
# - Generalise the summarise_by_orthography() function.
#     Currently it expects those exact column names.

# Data Subsetting Functions ----

subset_to_task <- function(data, task_input) {
  # Subset data to a task, then drop task from data
  # Inputs: data = data.frame object,
  #         task_input = name of column containing task
  #           to filter by (in quotes) (e.g. "W")
  data %>%
    filter(task == task_input) %>%
    ungroup(task) %>%
    dplyr::select(-task)
}

# Data Summary Functions ----

summarise_by_orthography <- function(data, orthography, na_rm = TRUE) {
  # Create a summary of descriptives for both DVs by othorgraphy condition
  # Inputs: data = data.frame object,
  #         orthography = name of column ID for orthography
  #           in quotes e.g. "transparent"

  if (na_rm == T) {
    data %>%
      filter(orthography_condition == orthography) %>%
      summarise(
        correct_mean = mean(lenient_correct, na.rm = TRUE),
        correct_sd = sd(lenient_correct, na.rm = TRUE),
        edit_mean = mean(lenient_nLED, na.rm = TRUE),
        edit_sd = sd(lenient_nLED, na.rm = TRUE)
      )
  } else {
    data %>%
      filter(orthography_condition == orthography) %>%
      summarise(
        correct_mean = mean(lenient_correct),
        correct_sd = sd(lenient_correct),
        edit_mean = mean(lenient_nLED),
        edit_sd = sd(lenient_nLED)
      )
  }
}

summarise_by_group <- function(data, groups, DV) {
  # Calculate mean and SD for a data set by groups and DV
  # Inputs: data = data.frame object,
  #         groups = list of groups (e.g. c("task", "block"))
  #         DV = name of dependent variable column (e.g. "lenient_nLED")
  DVs <- as.name(DV)
  data %>%
    group_by_(.dots = lapply(groups, as.symbol)) %>%
    summarise_(
      mean_score = lazyeval::interp(~mean(v, na.rm = TRUE),
        v = DVs
      ),
      sd_score = lazyeval::interp(~sd(v, na.rm = TRUE),
        v = DVs
      )
    )
}

paste_mean_sd <- function(data, mean_col, sd_col) {
  # Pastes sd values to mean values with sd in parentheses
  # useful for combining two values into one column in tables
  # Inputs: data = data.frame object containing numeric columns
  #         mean_col = column name for mean in quotes (e.g. "mean_nLED")
  #         sd_col = column name for sd (e.g. "sd_nLED")
  paste0(
    formatC( # forces 3 dp when pasting values
      data[[mean_col]],
      digits = 3,
      format = "f"
    ),
    " (",
    formatC(
      data[[sd_col]],
      digits = 3,
      format = "f"
    ),
    ")"
  )
}

# Data Tidying Functions ----

tidy_lme_by <- function(data, results_col = "results", collapse = TRUE) {
  # Tidy (g)lmer summary output
  # unnests and tidies a nested data frame with a results column containing
  # (g)lmer output, keeping only fixed effects and optionally collapsing 
  # multiple grouping columns into one column
  # Input: data = data.frame containing nested (g)lmerMod objects to be tidied
  #        results_col = string indicating the name of the results column
  #           that contains the (g)lmerMod objects. Defaults to "results" 
  #           as this is the default column name from lme_by().
  #        collapse = logical indicating whether or not to collapse grouping
  #           names into one column, defaults to TRUE
  data_copy <- data
  
  # mutate the results column by extracting (tidied) fixed effects
  data_copy[[results_col]] <- 
    data_copy[[results_col]] %>% map(
      ., 
      ~broom.mixed::tidy(.) %>% 
        filter(effect == "fixed") %>%
        dplyr::select(-c(group, effect))
    )
  if (collapse == TRUE) {
    # collapse across grouping columns for 1 ID column
    data_copy %>% 
      unite(group, -one_of(results_col), sep = " and ") %>%
      unnest(results)
    
  } else {
    # keep all grouping columns intact
    data_copy %>% 
      unnest(results)
  }
}

recode_lme <- function(tidied_merMod, names) {
  # Recodes names of the term column of a tidied (g)lmerMod object
  # Inputs: tidied_merMod = data.frame of (g)lmerMod object
  #           tidied using tidy_lme_by()
  #         names = list of names containing original and desired names
  #           e.g. list("(Intercept)" = "intercept")
  tidied_merMod[["term"]] <- recode(
    tidied_merMod[["term"]],
    !!!enquos(names) # splice list of elements as an argument into recode
  )
}

# Data Centering Functions ----

centre_var <- function(data, factor, level_one) {
  # Centres two level factors
  # Inputs: data = data.frame containing the relevant factor
  #         factor = column name (in quotes) for the factor to be centred
  #                   e.g. "task"
  #         level_one = the level to receive the positive coding
  #                       (in quotes), e.g. "R" (for reading)
  (data[[factor]] == level_one) - 
    mean(data[[factor]] == level_one, na.rm = TRUE)
}

centre_var_by_group <- function(input_data, centring_col, centring_level, ...) {
  # centres a variable within a number of specified groups.
  #   This is used for ensuring a variable is centred correctly
  #     prior to conducting pairwise tests.
  # Side effect (bug): columns of Duration data type are respecified as numeric
  # Inputs:
  #   input_data = data.frame containing grouping columns and column
  #     of a variable to be centred.
  #   centring_col = string of the column name to centre by
  #   centring_level = string of the level by which to centre; see
  #   the centre_var() function for details.
  #   ... = any bare column names by which to group the data prior to
  #     centring and fitting pairwise tests.
  # Outputs:
  #   data.frame containing all columns of the original input_data,
  #   but with an additional column centred by the group.
  #   This is the original column name appended by "_c",
  #     e.g.if input_data has "condition", and "condition_c",
  #     "condition_c" is the newly centred condition column.

  # check if the column has been centred before;
  # if so, remove the original centred column to avoid making
  # column names such as _c1, otherwise, don't remove anything.
  if (paste0(centring_col, "_c") %in% colnames(input_data)) {
    input_data %>%
      select(-one_of(c(paste0(centring_col, "_c")))) %>%
      group_by(!!!enquos(...)) %>%
      nest() %>%
      mutate(
        !!paste0(centring_col, "_c") := # parse as a bare column name
          map(data, ~centre_var(., centring_col, centring_level))
      ) %>%
      unnest()
  } else {
    input_data %>%
      group_by(!!!enquos(...)) %>%
      nest() %>%
      mutate(
        !!paste0(centring_col, "_c") := # parse as a bare column name
          map(data, ~centre_var(., centring_col, centring_level))
      ) %>%
      unnest()
  }
}

centre_many <- function(input_data, centring_list, by_group = FALSE, ...) {
  # Centres data.frame variables along several factors.
  # Optionally centres within any number of subgroups with by_group = T.
  #   This option is used for subgroup analyses where the initial centring
  #   may be incorrect. This defaults to F.
  # If by_group = T, you must pass on additional arguments for the
  #   bare column names (i.e. without quotes) by which to group the data;
  #   This uses non-standard evaluation, as with dplyr.
  # Relies on the centre_var_by_group() function, which in turn
  #   relies on the centre_var() function
  # Inputs: input_data = data.frame containing the factors to be centred
  #         centring_list = list containing two levels
  #             the first containing the factor IDs
  #             the second containing the level IDs,
  #             only one level ID is requires, and is the baseline.
  #             e.g. centring_list(factors = c("cond_one", "cond_two"),
  #                        levels = c("level_one", "level_two"))
  #         by_group = logical indicating whether (T) or not (F)
  #             to centre the variables within subgroups.
  #         ... = additional bare column names by which to group the
  #             data if by_group == T
  # Returns: data.frame with appended centred factors represented as
  #           the column name + _c (e.g. "condition" to "condition_c").
  if (by_group == FALSE) {
    for (i in seq(centring_list[[1]])) {
      input_data[[paste0(centring_list[[1]][i], "_c")]] <-
        centre_var(input_data, centring_list[[1]][i], centring_list[[2]][i])
    }
    as.tibble(input_data)
  } else {
    for (i in 1:length(centring_list[[1]])) {
      input_data <- input_data %>%
        centre_var_by_group(
          .,
          centring_list[[1]][i],
          centring_list[[2]][i],
          ...
        )
    }
    input_data
  }
}

# DV generating functions (arcsine square root) ----

make_asinsqrt <- function(data, proportion) {
  # Makes proportions and arsin square root transformed proportions
  # Inputs: data from which proportions should be calculated
  #         proportion = column containing a proportion (as quoted text)
  # Returns: data.frame with DV columns (prop, asin, and adjusted logit)
  # Note: Relies on the adjust_inf() function to adjust all proportions
  #         prior to calculating the logit, and the logit_transform()
  #         function to transform adjusted proportions to logits.
  data %>% mutate(asin = asin(sqrt(!!as.name(proportion))))
}

# NHST Functions ----

clean_lme_by <- function(nested_data_frame) {
  # filters a data frame with nested results in a column
  # named "results" (often the result of lme_by())
  # then it drops the Intercept term before (optionally) dropping
  # the term column (which is redundant with only 1 comparison)
  # Input: nested_data_frame = data frame with nested model output
  #           from broom.mixed::tidy() in the results column
  #        drop_term (defaults to FALSE) = logical operator
  #           indicating whether or not to drop the term from output
  #           since term is redundant when only doing 1 comparison
  # Output: data frame containing only fixed effects and group names
  test$results <- map(
    test$results, ~broom.mixed::tidy(.) %>% 
      filter(effect == "fixed") %>%
      select(-c(group, effect))
  )
}

lme_by <- function(data, formula, ...) {
  # Runs lme on a factor within groups (for interactions)
  #   and returns a nested data.frame of model fits
  # Inputs: data = data.frame from which comparisons will be made
  #         formula = string outlining fixed and random effects
  #                     to test for a remaining factor
  #                   e.g. "asin ~ factor_one + (1 | subjects)"
  #         ... = bare name of groups to group by (i.e. no quotes needed)
  # Note: Defaults to 1e5 as the maximum number of function evaluations to fit
  data %>%
    group_by(!!!enquos(...)) %>%
    do(results = lmer(
      formula, 
      data = .,
      control = lmerControl(optCtrl = list(maxfun = 1e5))
    ))
}

collapse_pairwise_df_cols <- function(data, ...) {
  # Collapses cell labels from multiple columns into one (called group)
  #   and removes the old columns.
  # Input: Data = a data frame of model outputs,
  #          tidied using broom.mixed::tidy().
  #   Note: The grouping factors must come before the term or p.value columns!
  # ... = bare column names of which to collapse across (i.e. no quotes)
  # Output: a tibble with the collapsed group labels in the first column
  #           followed by the term and test statistic columns
  data %>%
    mutate(group = paste(!!!enquos(...), sep = " and ")) %>%
    select(group, everything(), -c(!!!enquos(...)))
}

# Bayesian Model Functions ----

evaluate_model_pair_bf <- function(
  formula_one,
  formula_two,
  random_factors,
  never_exclude,
  data,
  iterations
) {
  # Calculates Bayes Factors for two models and the comparison between them.
  #   This is used for calculating Bayes Factors for one factor/variable.
  # Inputs:
  #   formula_one = formula of main model with term included
  #   formula_two = formula of main model with term removed
  #                 (update is useful here)
  #   random factors = vector containing strings of columns
  #                   containing random factors
  #   never exclude = vector containing strings of columns to keep in all models
  #   data = data.frame containing data on which to fit models
  # Output: A list of fitted model objects;
  #   BF10 = model corresponding to first formula
  #   BF20 = model corresponding to second formula
  #   BF12 = model one compared to model two
  #   BF21 = inverse of the above
  model_one <- generalTestBF(
    formula = formula_one,
    data = data,
    whichRandom = random_factors,
    neverExclude = never_exclude,
    progress = FALSE,
    iterations = iterations
  )
  model_two <- generalTestBF(
    formula = formula_two,
    data = data,
    whichRandom = random_factors,
    neverExclude = never_exclude,
    progress = FALSE,
    iterations = iterations
  )
  list(
    "BF_10" = model_one,
    "BF_20" = model_two,
    "BF_12" = model_one / model_two,
    "BF_21" = model_two / model_one
  )
}

summarise_model_pair_bf <- function(list_of_models) {
  # Extracts Bayes Factors and error terms for two models fitted with
  #   evaluate_model_pair_bf() and creates a simple data.frame output
  #   of the results comparing from the two models (including)
  #   the original model fits and a comparison of those models.
  # Inputs:
  #   list_of_models = list of BFBayesFactor models fitted
  #     generated by evaluate_model_pair_bf()
  # Output: data.frame containing
  #   a model identifier, Bayes Factors, and error terms;
  #   BF_10 = original model fit for the first fitted model
  #   BF_20 = original model fit for the second fitted model
  #   BF_12 = comparison of the first vs the second model
  #   BF_21 = comparison of the second vs the first model
  #   BF = Bayes Factor
  #   error = error term for associated model/model comparison.
  output <- data.frame(
    model = seq_along(list_of_models),
    BF = seq_along(list_of_models),
    error = seq_along(list_of_models)
  )

  for (i in seq_along(list_of_models)) {
    output$model[i] <- names(list_of_models)[i]
    output$BF[i] <- as.data.frame(
      list_of_models[[names(list_of_models)[i]]]
    )$bf
    output$error[i] <- as.data.frame(
      list_of_models[[names(list_of_models)[i]]]
    )$error
  }
  output
}

test_pairwise_bf <- function(
  input_data,
  formula_one,
  formula_two = NULL,
  randoms = NULL,
  never_excludes = NULL,
  iterations = 1e4,
  ...
) {
  # Calculates Bayes Factors for one or two models grouped by variables.
  #   This is used for generating Bayes Factors for pairwise tests
  #   (i.e. split by several variables/factors).
  # Inputs:
  #   input_data = data.frame containing the factors of interest.
  #   formula_one = formula of the first model
  #                   (e.g. main model with term included).
  #   formula_two = formula of the second model
  #                   (e.g. main model with term excluded).
  #                   (tip - use: update(formula_one, ~. -factor_of_interest).
  #                 Defaults to NULL whereby only the first model is computed.
  #   randoms = vector containing strings of columns
  #                     containing random factors.
  #                    Defaults to NULL.
  #   never_excludes = vector containing strings of columns
  #                     to keep in the most complex model.
  #                    Defaults to NULL.
  #   iterations = number of iterations used to fit the model.
  #                 More iterations = lower error rate on BFs.
  #                 Defaults to 1e4 (generalTestBF default).
  #   ... = optional variables by which to group data before analysis
  # Output: tibble of grouping variables and two nested columns containing
  #         fitted BFBayesFactor objects.
  #   model_one = model_one fitted to the groups in the given row.
  # optional if model_two != NULL:
  #   model_two = model_two fitted to the groups in the given row.
  if (is.null(formula_two)) {
    input_data %>%
      group_by(!!!enquos(...)) %>%
      nest() %>%
      mutate(
        model = map(data, ~
      generalTestBF(
        formula_one,
        data = .,
        whichRandom = randoms,
        neverExclude = never_excludes,
        iterations = iterations
      ))) %>%
      select(-data) # remove data from returned df
  } else {
    input_data %>%
      group_by(!!!enquos(...)) %>%
      nest() %>%
      mutate(
        model_one = map(data, ~
        generalTestBF(
          formula_one,
          data = .,
          whichRandom = randoms,
          neverExclude = never_excludes,
          iterations = iterations
        )),
        model_two = map(data, ~
        generalTestBF(
          formula_two,
          data = .,
          whichRandom = randoms,
          neverExclude = never_excludes,
          iterations = iterations
        ))
      ) %>%
      select(-data) # remove data from returned df
  }
}

extract_pairwise_model_comparison_bf <- function(
  data,
  model_one_col,
  model_two_col = NULL,
  term = "bf"
) {
  # Extracts Bayes Factors (by default) or error terms from
  #   a tibble of grouping variables and one or two nested BFBayesFactor models
  #   created from test_pairwise_bf().
  #   This is used in the summarise_model_comparison_bf() function.
  # Inputs:
  #   data = tibble containing two columns of nested BFBayesFactor objects.
  #   model_one_col = text string (quoted) of the column name
  #     containing results fitted to the first model.
  #   model_two_col (optional) = text string (quoted) of the column name
  #     containing results fitted to the second model.
  #     Defaults to NULL.
  #   term = string ("bf" or "error") indicating whether the term extracted
  #           from the fitted models is the Bayes Factor or proportional error.
  #          Defaults to "bf".
  # Output: vector of Bayes Factors or error terms comparing models fitted
  #           and stored in the model_one_col and
  #           optionally to the model_two_col.
  #         Note: for two models make model_one_col your first column for BF_12
  #               For BF_21, reverse the order. Error terms are the same
  #               regardless of the order of input.
  output <- as.numeric(seq_len(nrow(data)))
  if (is.null(model_two_col)) {
    if (term == "bf") {
      for (i in seq_len(nrow(data))) {
        output[i] <- as.data.frame(data[[model_one_col]][[i]])$bf
      }
    } else if (term == "error") {
      for (i in seq_len(nrow(data))) {
        output[i] <- as.data.frame(data[[model_one_col]][[i]])$error
      }
    } else {
      print("incorrect error term selected: please use bf or error.")
    }
  } else {
    if (term == "bf") {
      for (i in seq_len(nrow(data))) {
        output[i] <- as.data.frame(data[[model_one_col]][[i]] /
          data[[model_two_col]][[i]])$bf[1]
      }
    } else if (term == "error") {
      for (i in seq_len(nrow(data))) {
        output[i] <- as.data.frame(data[[model_one_col]][[i]] /
          data[[model_two_col]][[i]])$error[1]
      }
    } else {
      print("incorrect error term selected: please use bf or error.")
    }
  }
  output
}

summarise_model_comparison_bf <- function(
  nested_pairwise_bf,
  model_one_col,
  model_two_col = NULL
) {
  # Extracts Bayes Factors and error terms from a dataframe containing
  #   of nested BFBayesFactor models created from test_pairwise_bf().
  #   This can take either one column of BFBayesFactor models, producing
  #     the Bayes factors for and against the null,
  #     or two columns of models to compare against one another.
  #   Relies on extract_pairwise_model_comparison_bf() to work.
  # This is used for making a simple data.frame output of results from
  #   pairwise comparisons for Bayes Factors.
  # Inputs:
  #   nested_pairwise_bf = tibble containing two columns of
  #     nested BFBayesFactor objects.
  #   model_one_col = text string (quoted) of the column name
  #     containing results fitted to the first model.
  #   optional: model_two_col = text string (quoted) of the column name
  #     containing results fitted to the second model.
  #     Defaults to NULL.
  # Output: data.frame containing any grouping variables present in
  #   nested_pairwise_bf with additional Bayes factors comparing the
  #   model fitted in model_one_col as BF_10 and BF_01.
  #   Optionally compares models contained in model_one_col
  #     against model_two_col (BF_12), and the inverse (BF_21),
  #   Both produce the error term associated with model comparisons (error).
  if (is.null(model_two_col)) {
    nested_pairwise_bf %>%
      mutate(
        BF_10 = extract_pairwise_model_comparison_bf(
          ., model_one_col, term = "bf"
        ),
        BF_01 = 1 / BF_10,
        error = extract_pairwise_model_comparison_bf(
          ., model_one_col, term = "error"
        )
      ) %>%
      select(-one_of(c(model_one_col)))
  } else {
    nested_pairwise_bf %>%
      mutate(
        BF_12 = extract_pairwise_model_comparison_bf(
          ., model_one_col, model_two_col, "bf"
        ),
        BF_21 = extract_pairwise_model_comparison_bf(
          ., model_two_col, model_one_col, "bf"
        ),
        error = extract_pairwise_model_comparison_bf(
          ., model_one_col, model_two_col, "error"
        )
      ) %>%
      select(-one_of(c(model_one_col, model_two_col)))
  }
}