# Names for parameter estimates in all experiments

rename_complex_terms <- function(model_summary, col_name = "term") {
  # Renames terms by collapsing strings and replacing individual
  # elements with pretty formatted elements.
  # This way, terms to replace do not need to exactly match
  # the entire string. 
  # e.g. replacing "time" with "Time" affects all terms including "time"
  # rather than the exact match of "time".
  # Inputs: 
  #   model_summary = a model summary, typically an
  #     lmer model tidied using the tidy_lme() function.
  #   col_name = a column name by which to replace all strings 
  #               (defaults to "term")
  # Outputs: a tidied model with pretty formatted names in the col_name column
  
  # backslashes escape backslashes in R so it can parse them as a string
  # you thus need four to make LaTeX symbols e.g. $\times$ = $\\\\times$
  col_names <- model_summary[[col_name]] %>%
    str_c(collapse = "---") %>%
    str_replace_all(c(
      "\\(Intercept\\)" = "Intercept",
      "ot1" = "Time",
      "poly\\(block_num, 1\\)" = "Time",
      "poly\\(block_num, 2\\)1" = "Time",
      "poly\\(block_num, 2\\)2" = "Time$\\^2$",
      "ot2" = "Time$\\^2$",
      "poly\\(block_num, 2\\)2" = "Time (Quadratic)",
      "language_variety1" = "Language Variety",
      "language_varietystandard" = "Standard",
      "language_varietydialect" = "Dialect",
      "picture_condition1" = "Picture Condition",
      "picture_conditionpicture" = "Picture",
      "picture_conditionno_picture" = "No Picture",
      "dialect_words1" = "Word Type",
      "dialect_words2" = "Word Familiarity",
      "task1" = "Task",
      "taskR" = "Reading",
      "taskW" = "Writing",
      ":" = " $\\\\times$ " # 4 escapes properly in kableExtra
      )
    ) %>%
    str_split(pattern = "---") 
  
  col_names %>% unlist()
}

rename_simple_terms <- function(model_summary) {
  # Renames terms in all non-numeric columns by doing 
  # an exact string replacement. 
  # e.g. renaming "R" to "Reading" affects "R" only, and not
  # other terms containing "R" such as "R:picture_condition".
  # Inputs: model_summary = summary of models, typically BayesFactor model
  #           produced using the summarise_model_comparison_bf() function.
  # Outputs: model_summary with terms with pretty formatting.
  # Side effect: coerces factors to characters
  model_summary %>% 
    mutate_if(
      funs(!is.numeric(.)), # excludes numeric cols from coersion to character
      funs(
        str_replace_all(., c(
          "R" = "Reading",
          "W" = "Spelling",
          "dialect" = "Dialect",
          "standard" = "Standard",
          "no_picture" = "No Picture", # must come first, or Picture breaks it
          "picture" = "Picture"
        ))
      ))
}

rename_cols <- function(model_summary) {
  # Renames any column names containing any of the factors
  # of interest in the study for pretty formatting.
  # Inputs: model_summary = summary of models, typically BayesFactor model
  #            produced using the summarise_model_comparison_bf() function.
  # Outputs: model_summary with column names with pretty formatting.
  model_summary %>% rename_all(
    recode, 
    language_variety = "Language Variety", 
    picture_condition = "Picture Condition",
    error = "Error",
    task = "Task"
  )
}

rename_all_terms <- function(model_summary) {
  # Renames all columns and cells containing factor labels
  # Inputs: model_summary = summary of models, typically BayesFactor model
  #            produced using the summarise_model_comparison_bf() function.
  # Outputs: model_summary with column and cell names with pretty formatting.
  model_summary %>% 
    rename_simple_terms() %>%
    rename_cols
}

format_BF_cols <- function(BF_model_summary, matches = "BF") {
  # Places $ around any column names containing BF
  # so that they are formatted in Math mode for LaTeX
  # additionally puts any parts of the string after an
  # underscore into curly braces for proper formatting
  # of subscripts
  if(any(stringr::str_detect(names(BF_model_summary), paste0(matches, "_")))) {
    # if it contains different columns with subscript IDs...
    BF_model_summary %>%
      rename_at(vars(contains(matches)), funs(
        paste0(
          str_split(., "_", simplify = TRUE)[, 1],
          "_{", 
          str_split(., "_", simplify = TRUE)[, 2],
          "}"
        )
      )) %>%
      rename_at(vars(contains(matches)), funs(paste0("$", ., "$")))
  }
  else if (any(stringr::str_detect(names(BF_model_summary), matches))) {
    # otherwise, if it contains any columns with just the bare ID
    BF_model_summary %>%
      rename_at(vars(contains(matches)), funs(paste0("$", ., "$")))
  }
}

format_BF_cells <- function(
  BF_model_summary, 
  col = NULL, 
  col_name = NULL, 
  col_id = NULL, 
  matches = "BF"
) {
  # Renames any strings containing BF in a given column to 
  # have $ at the beginning and end of the string.
  # This is used for Math expressions in LaTeX presentation.
  # Defaults to searching columns called model (bare name, no ""), and
  # strings called "BF" (as a string, including "").
  # Output, the same data.frame with a column providing 
  # $$ surrounded names for LaTeX.
  # uses NSE so bare data.frame and column names can be passed
  # input = BF_model_summary
  if (missing(col_name) & missing(col_id)) {
    col_name <- quo_name(enquo(col)) # quotes symbol as a name for assignment
    col_id <- enquo(col) # quotes symbol for use in function
  } else {
    # do nothing, col_name and col_id have already been passed
    # in their properly quosured form
  }
  BF_model_summary %>% 
    mutate(
      !!col_name := case_when(
        str_detect(!!col_id, matches) ~ paste0(
          "$", 
          str_split(!!col_id, "_", simplify = TRUE)[, 1],
          "_{",
          str_split(!!col_id, "_", simplify = TRUE)[, 2],
          "}$"
        )
      )
    )
}

format_BF_results <- function(
  BF_model_summary, 
  col = NULL, 
  matches = "BF", 
  err_percent = TRUE
) {
  
  # format any cols containing the matching string
  output <- BF_model_summary %>%
    format_BF_cols(., matches = matches)
  
  # if a specific column for matching strings is provided
  # format all cells that contain the matching string
  if (!missing(col)) {
    col_name <- quo_name(enquo(col)) # quotes symbol as a name for assignment
    col_id <- enquo(col) # quotes symbol for use in function
    
    output <- output %>%
      format_BF_cells(
        ., 
        col_name = col_name, 
        col_id = col_id, 
        matches = matches
      )
  }
  
  # if conversion of error proportions to percentages is requested
  # do so...
  if (err_percent == TRUE) {
    output %>% mutate(error = error * 100) # error proportion to percentage
  } else {
    output
  }
}