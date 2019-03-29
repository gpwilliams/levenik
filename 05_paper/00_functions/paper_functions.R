# Functions for use in the Levenik study
# Author: Dr. Glenn P. Williams

# Data Summary Functions ----

round_pad <- function(x, digits = 2) {
  # works like round() but always retains digits (i.e. in cases of trailing 0)
  # WARNING: returns a character vector, so only use for presentation purposes
  formatC(round(x, digits), format = "f", digits = digits)
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

paste_mean_sd <- function(data, mean_col, sd_col, digits = 2) {
  # Pastes sd values to mean values with sd in parentheses
  # useful for combining two values into one column in tables
  # Inputs: data = data.frame object containing numeric columns
  #         mean_col = column name for mean in quotes (e.g. "mean_nLED")
  #         sd_col = column name for sd (e.g. "sd_nLED")
  #         digits = numeric indicating rounding for values (defaults to 2)
  paste0(
    formatC( # forces 3 dp when pasting values
      data[[mean_col]],
      digits = digits,
      format = "f"
    ),
    " (",
    formatC(
      data[[sd_col]],
      digits = digits,
      format = "f"
    ),
    ")"
  )
}

summarise_icc <- function(icc_model, round = 2) {
  # Produces a string summary of the model returned from
  # irr:icc(), using rounding with left padding on all values
  # Inputs: icc_model = Model produced using irr:icc()
  #         round = 2 (default), numeric indicating by how many decimals 
  #                 to round. This also controls the padding of values.
  # Outputs: String summary of model
  icc_summary <- icc_model[c(
    "df1",
    "df2",
    "Fvalue",
    "p.value",
    "value",
    "conf.level",
    "lbound",
    "ubound"
  )]
  
  # extract p-value and print prettily
  p_value <- papa(icc_model$p.value, asterisk = FALSE)
  
  if(!grepl("<", p_value)) {
    # if p doesn't contain a less than, add an equals
    p_value <- paste("=", p_value, sep = " ")
  }
  
  with(
    lapply(icc_summary, round_pad, round),
    paste0(
      "F(",
      df1,
      ", ",
      df2,
      ") = ",
      Fvalue,
      ", $p$ ",
      p_value,
      ", ICC = ",
      value,
      " [",
      substr(conf.level, 3, 4), # make into %
      "% CI = ",
      lbound, "; ",
      ubound, "]"
    )
  )
}

summarise_lme <- function(merMod, col, names, asterisk = FALSE){
  # summarises an lme4 model by tidying the input and merging CI limits
  # then uses provided column names and replacements for prettier printing
  # of model terms and properly formats p-values.
  # Inputs: merMod = a saved model from lme4
  #         col = bare column name containing strings to be renamed
  #         names = named characters of original string names and replacement
  #           strings. For example: names <- c("any_string" = "Any String"). 
  #           If abbreviate_interactions == TRUE, only changes main effects
  #           WARNING: This must be changed if any strings contain "---"
  #         asterisk: logical (default FALSE) indicating whether or not to add
  #           asterisks for levels of significance to p-values.
  # Outputs: tibble of tidied lme4 fixed effects outputs
  colname <- enquo(col)
  
  merMod %>%
    tidy_lme() %>%
    merge_CI_limits(., "2.5 %", "97.5 %") %>%
    rename_many(., !!colname, names, TRUE, interaction_terms) %>%
    mutate(p.value = papa(p.value, asterisk = asterisk)) %>%
    select(term:std.error, `95% CI`, statistic:p.value)
}

summarise_bayes <- function(brms_summary, col, names){
  # summarises the fixed effects from a brms model object by tidying the input
  # and merging CI limits, then uses provided column names and replacements 
  # for prettier printing of model terms.
  # Inputs: brms_summary = a summary of a brmsfit object
  #         col = bare column name containing strings to be renamed
  #         names = named characters of original string names and replacement
  #           strings. For example: names <- c("any_string" = "Any String"). 
  #           If abbreviate_interactions == TRUE, only changes main effects
  #           WARNING: This must be changed if any strings contain "---"
  # Outputs: tibble of tidied brms "fixed" effects outputs
  term_cell_names <- dimnames(brms_summary)[[1]]
  
  colname <- enquo(col)
  
  brms_summary %>%
    as_tibble() %>%
    mutate(term = term_cell_names) %>%
    select(term, everything()) %>%
    rename_many(., !!colname, names, TRUE, interaction_terms) %>%
    merge_CI_limits(., "l-95% CI", "u-95% CI") %>%
    select(term:Est.Error, `95% CI`)
}

# Data Tidying Functions ----

make_confint <- function(merMod, confint_method = "Wald") {
  # Makes confidence intervals using various methods
  # for models fitted in lme4
  # Inputs: merMod = a saved model from lme4
  #         confint_method = method for calculating confidence intervals
  #         see confint.merMod methods
  merMod %>%
    confint(., method = confint_method) %>%
    na.omit() %>% # removes uncalcualted intervals for non fixed terms
    as.data.frame() %>%
    tibble::rownames_to_column(., "term")
}

tidy_lme <- function(merMod, confint = TRUE, ...) {
  # Inputs: merMod = a saved model from lme4
  #         confint = whether or not to calcualte confidence intervals 
  #           (default = TRUE)
  # Outputs: data.frame of tidied fixed effects and p-values
  #           Note: p-values calculated via the normal approximation
  if (confint == TRUE) {
    confints <- make_confint(merMod, ...)
  }
  tidied_model <- broom::tidy(merMod, effect = "fixed") %>% 
    dplyr::select(-effect)
  if (confint == TRUE) {
    left_join(tidied_model, confints, by = "term")
  } else {
    tidied_model
  }
}

merge_CI_limits <- function(data, lower, upper, round = TRUE, decimals = 2) {
  # Pastes two columns together in brackets separated by a comma
  # Use: used to paste lower and upper CI together after tidying model with
  #       tidy_ordinal_model()
  # Inputs: data = data.frame with lower and upper CI bounds as columns
  #         lower = string of lower confidence limit column name
  #         upper = string of upper confidence limit column name
  #         round = TRUE (default), logical indicating whether or not to round
  #                 values in the CI columns prior to pasting (recommended)
  #         decimals = 2 (default), integer indicating how many values to
  #             round numbers by if rounding occurs. Ignored if round = FALSE.
  # Returns: data.frame with merged CI levels in one column, with prior
  #           lower and upper bound columns removed.
  
  # force standard evaluation; used with !! later
  lower = sym(lower)
  upper = sym(upper)
  
  if(round == TRUE) {
    data %>% mutate("95% CI" = paste0(
      "[", 
      # formatC used to force R to keep trailing zeroes
      formatC(round(!!lower, decimals), format = "f", digits = decimals), 
      ", ", 
      formatC(round(!!upper, decimals), format = "f", digits = decimals),
      "]"
    )) %>%
      select(-!!lower, -!!upper)
  } else {
    data %>% 
      mutate("95% CI" = paste0("[", !!lower, ", ", !!upper, "]")) %>%
      select(-!!lower, -!!upper)
  }
}

rename_many <- function(data, 
                        col, 
                        names, 
                        abbreviate_interactions = FALSE, 
                        interaction_names = NULL,
                        separation = ":",
                        collapse_method = "---") {
  # Renames all instances of strings evaluated from named characters
  # in a data.frame for pretty printing in tables.
  # 
  # Inputs:
  #   data = data.frame containing a column with strings to be renamed
  #   col = bare column name containing strings to be renamed
  #   names = named characters of original string names and replacement
  #     strings. For example: names <- c("any_string" = "Any String"). 
  #     If abbreviate_interactions == TRUE, only changes main effects
  #     WARNING: This must be changed if any strings contain "---"
  #   abbreviate_interactions = logical (defaults to FALSE). If TRUE, names 
  #     changes only main effects and interaction_names changes only 
  #     interaction terms
  #   interaction_names = named characters of original string names 
  #     and replacement strings for interaction terms. 
  #     For example: names <- c("any_string" = "Any String")
  #   separation = character string defining where to divide main and interaction
  #     labels. Defaults to : which lme4 uses to highlight interactions.
  #   collapse_method = a character vector used to keep string names
  #     apart from one another during renaming. This defaults to "---".
  # Returns: data.frame with renamed strings in the designed column.
  colname <- enquo(col)
  
  if (abbreviate_interactions == TRUE) {
    if(is.null(interaction_names)) {
      stop("No terms passed to interaction_names")
    }
  main_labels <- str_subset(data[[quo_name(colname)]], separation, negate = TRUE) %>%
    str_c(collapse = collapse_method) %>%
    str_replace_all(names) %>%
    str_split(pattern = collapse_method) %>% 
    unlist()
  
  interaction_labels <-
    str_subset(data[[quo_name(colname)]], separation, negate = FALSE) %>%
    str_c(collapse = collapse_method) %>%
    str_replace_all(interaction_names) %>%
    str_split(pattern = collapse_method) %>% 
    unlist()
    
  data %>% mutate(!!colname := c(main_labels, interaction_labels))
  } else {
    labels <- data[[quo_name(colname)]] %>%
      str_c(collapse = collapse_method) %>%
      str_replace_all(names) %>%
      str_split(pattern = collapse_method) %>% 
      unlist()
    
    data %>% mutate(!!colname := labels)
  }
    
}

rename_nested_terms <- function(model_summary, 
                                eval = "WT|WF", 
                                col = term, 
                                replacements = 
                                  c(" \\$\\\\times\\$" = ",", 
                                    ", WT" = ": WT")) {
  
  colname <- enquo(col)
  
  model_summary %>%
    mutate(
      !!colname := dplyr::case_when(
        str_detect(!!colname, eval) ~ str_replace_all(!!colname, replacements),
        TRUE ~ !!colname
      )
    )
}

# DV generating functions (arcsine square root) ----

make_asinsqrt <- function(data, proportion) {
  # Makes proportions and arsin square root transformed proportions
  # Inputs: data from which proportions should be calculated
  #         proportion = column containing a proportion (as quoted text)
  # Returns: data.frame with DV columns (prop, asin, and adjusted logit)
  data %>% mutate(asin = asin(sqrt(UQ(as.name(proportion)))))
}

# NHST Functions ----

# note, while scales::pvalue() provides a much easier way to do this
# it left pads with a 0 (not APA) and does not provide asterisks

papa_engine <- function(num, 
                        digits = 3, 
                        tolerance = .001, 
                        nsmall = 3, 
                        asterisk = TRUE) {
  # pAPA: Formats p-values to APA standards, removing leading zeroes
  # and formatting values below the tolerance to < the tolerance
  # by default this tolerance is .001, and p-values are reported
  # to 3 digits. 
  # This keeps trailing zeroes to 3 decimal places by default (nsmall)
  # unless p == 1, where only 2 decimals are reported.
  # Inputs:
  #   num = Numeric vector of p-values
  #   digits = Digits by which to round (default = 3)
  #   tolerance = Limit by which to report smaller values with < tolerance
  #   nsmall = Number of trailing zeroes to keep when rounding
  #   asterisk = Whether or not to include asterisks for different 
  #     "levels" of significance. These values are * <.05; ** <.01; *** <.001
  # note we do not use format.pval as this gives results to 3sf
  if (!is.numeric(num)) {
    stop("Input is non-numeric and cannot be rounded.")
  } else {
    # format p-value
    rounded_pval <- round(num, digits)
    rounded_formatted_pval <- format(rounded_pval, nsmall = nsmall)
    if (rounded_pval < tolerance) {
      output_pval <- paste0("<", tolerance)
    } else {
      output_pval <- rounded_formatted_pval
    }
    # additional formatting
    if (rounded_pval == 1) {
      # remove trailing zero (to keep 3sf)
      substr(output_pval, 1, nchar(output_pval)-1)
    } else {
      # if number is less than tolerance (default of .001)
      if (rounded_pval < tolerance) {
        if (asterisk == TRUE) {
          paste0(gsub("<0", "< ", output_pval), "***")
        } else {
          gsub("<0", "< ", output_pval)
        }
      } else {
        # if number isn't less than tolerance (default of .001)
        if (asterisk == TRUE) {
          if (rounded_pval < .01) {
            paste0(substring(output_pval, 2), "**")
          } else if (rounded_pval < .05) {
            paste0(substring(output_pval, 2), "*")
          } else {
            substring(output_pval, 2)
          }
        } else {
          substring(output_pval, 2)
        }
      }
    }
  }
}

papa <- function(num, ...) {
  # a vectorised form of the papa_engine function
  # Inputs = numeric vector of values to be turned into p-values
  # ... = additional arguments passed to papa_engine()
  # Outputs = numeric vector of p-values
  sapply(
    num, 
    papa_engine, 
    ...,
    simplify = TRUE
  )
}