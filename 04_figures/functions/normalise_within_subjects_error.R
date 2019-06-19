###############################################################################
# Functions:   (1) Calculate between-subjects SE for plots
#             (2) Normalise data for preparation before calculating...
#             (3) ...Within-subjects SE for plots (i.e. 3 depends on 2)
###############################################################################

# calculates error bars reflect within-subject error
#   using the Morey (2008) correction
# see: http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_
#   (ggplot2)/#error-bars-for-within-subjects-variables

###############################################################################
# Instantiate functions
###############################################################################

summariseBetween <- function(data, subj_ID,
                             groupingVariables,
                             dependentVariable,
                             errorTerm) {
  # Returns a summary of data that based on (between-subjects) grouping variables:
  #   calculates means, sds and an error term based on SE OR Confint
  #   Multiply this error term by the SD to get SE/Confint as necessary.
  #
  # Args:
  #   data: input dataframe.
  #
  #   groupingVariables: groups from which to summarise the data;
  #     a character vector of column names from the data,
  #       e.g. c("block", "dialect_words").
  #
  #   dependentVariable: the column containing the dependent
  #       varaible in the data; a character vector pointing to the DV column,
  #         e.g. "primaryCoder_nLED"
  #
  #   errorTerm: a character vector defining which error term
  #     should be calculated. This must take either
  #       "Standard Error" or "95% Confidence Interval"
  #
  #   NOTE: all variables based on character vectors can be
  #     instantiated in 2 ways:
  #       (1) as an object: e.g. Error <- "Standard Error",
  #           then pass Error to the function
  #       (2) as plain text in quotations: e.g. "Standard Error".
  #
  # Returns: a summary tibble of descriptive statistics.

  # strip quotations from the dependent variable and assign to an object
  DVs <- as.symbol(dependentVariable)
  subj_ID <- as.symbol(subj_ID)

  # convert character vector of groups to a list of symbols
  dots <- lapply(groupingVariables, as.name)

  # summary stats; NA removed
  outputData <- data %>%
    group_by_(.dots = dots) %>%
    summarise(
      N = length(unique(!!subj_ID)),
      means = mean(!!DVs, na.rm = T),
      sds = sd(!!DVs, na.rm = T),
      counts = length(!!subj_ID)
    )

  # calculate SE or 95% confidence intervals?
  if (errorTerm == "Standard Error") {
    outputData$Err <- 1 / sqrt(outputData$N)
  } else if (errorTerm == "95% Confidence Interval") {
    outputData$Err <- qt(0.975, df = outputData$N - 1) / sqrt(outputData$N)
  } else {
    stop("errorTerm must be \"Standard Error\" or \"95% Confidence Interval\"")
  }
  return(outputData)
}

normaliseData <- function(data, subj_ID, betweenGroups, dependentVariable) {
  # Normalises mean scores for a dependent variable in a dataframe
  #   based on between-subjects groups.
  # Normalised scores are used for calculating within-subject error terms.
  #
  # Args:
  #   data: input dataframe
  #
  #   subj_ID: the name of the column identifying each participant in the data;
  #     a character vector, e.g. "participant_number".
  #
  #   betweenGroups: between-subjects groups from which to summarise the data;
  #     a character vector of column names from the data,
  #       e.g. "language_variety".
  #     These must all be between-subjects variables.
  #
  #   dependentVariable: the column containing the dependent varaible
  #     in the data; a character vector pointing to the DV column,
  #       e.g. "primaryCoder_nLED"
  #
  # Returns: input dataset with an additional column of a
  #   normalised dependent variable.

  # strip quotes from DV and participant IDs
  DVs <- as.name(dependentVariable)
  participant <- as.name(subj_ID)

  # add participant_number to your grouping variables
  betweenGroups <- c(participant, betweenGroups)

  # convert character vector of groups to a list of symbols
  dots <- lapply(betweenGroups, as.symbol)

  # calculate means by your input groups for each participant; NA removed
  subjectMeans <- data %>%
    group_by_(.dots = dots) %>%
    summarise(subject_means = mean(!!DVs, na.rm = TRUE))

  # merge the full data with the subject means
  outputData <- merge(data, subjectMeans, full = TRUE)

  # create an identifier for the normed dependent variable
  normedDV <- paste0("normed_", DVs)

  # create normedDV from DV - subject_means + mean for everyone
  outputData[, normedDV] <- outputData[, dependentVariable] -
    outputData[, "subject_means"] +
    mean(outputData[, dependentVariable], na.rm = TRUE)

  # remove subject mean column
  outputData$subject_means <- NULL

  return(outputData)
}

summariseWithin <- function(data,
                            subj_ID,
                            withinGroups,
                            betweenGroups,
                            dependentVariable,
                            errorTerm) {
  # Returns a summary of data that contains within-subjects
  #   (and/or not between-subjects) variables:
  #   calculates means, sds and an error term based on SE OR Confint
  #   Multiply this error term by the SD to get SE/Confint as necessary.
  #
  # Args:
  #   data: input dataframe.
  #
  #   subj_ID: the name of the column identifying each participant in the data;
  #     a character vector, e.g. "participant_number".
  #
  #   withinGroups: within subjects groups;
  #     a character vector of column names from the data,
  #       e.g. c("block", "dialect_words").
  #
  #   betweenGroups: between subjects groups;
  #     a character vector of column names from the data,
  #       e.g. c("language_variety", "picture_condition").
  #
  #   dependentVariable: the column containing the
  #     dependent varaible in the data; a character vector pointing to the
  #       DV column, e.g. "primaryCoder_nLED"
  #
  #   errorTerm: a character vector defining which error term
  #     should be calculated. This must take either
  #       "Standard Error" or "95% Confidence Interval"
  #
  # Returns: a summary tibble of descriptive statistics normalised by
  #   within-subjects groups.

  # calculate non-normed descriptive statistics from your data
  uncorrectedSummary <- summariseBetween(
    data,
    subj_ID,
    groupingVariables =
      c(withinGroups, betweenGroups),
    dependentVariable,
    errorTerm
  )

  # norm the data
  normedData <- normaliseData(
    data,
    betweenGroups,
    subj_ID,
    dependentVariable
  )

  # drop unused cols (i.e. N, counts, sds, and Err) from the uncorrected 
  #   summary; we use normed ones
  drop_cols <- c("N", "counts", "sds", "Err")
  uncorrectedSummary <- uncorrectedSummary %>% select(-one_of(drop_cols))

  # get summarised descriptive statistics based on the normed dependent variable
  correctedSummary <- summariseBetween(
    normedData,
    subj_ID,
    groupingVariables =
      c(withinGroups, betweenGroups),
    paste0(
      "normed_",
      dependentVariable
    ),
    errorTerm
  )

  # drop means from the corrected summary
  correctedSummary <- correctedSummary %>% select(-means)

  # generate Morey (2008) correction factor
  nWithinGroups <- prod(vapply(
    correctedSummary[, withinGroups, drop = FALSE],
    FUN = function(x) length(unique(x)), 
    FUN.VALUE = numeric(1)
  ))
  correctionFactor <- sqrt(nWithinGroups / (nWithinGroups - 1))

  # apply the correction factor to the sds and merge summaries
  correctedSummary$sds <- correctedSummary$sds * correctionFactor
  outputData <- merge(uncorrectedSummary, correctedSummary)

  return(outputData)
}