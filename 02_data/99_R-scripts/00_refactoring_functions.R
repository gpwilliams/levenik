# Refactoring Functions

# not in: inverse of %in%
'%!in%' <- function(x, y)!('%in%'(x, y))

min_max_index <- function(input_data, calculation) {
  # Calculate index of inputted values with min/max value
  # Inputs: 
  #   input_data = numeric data
  #   calculation = string indicating "min" or "max" for
  #       determining if the function returns the minimum 
  #       or maximum value respectively
  # Returns: numeric data giving the index of the min/max value
  # Note, if all inputs are NA, this returns NA
  if (all(is.na(input_data))) {
    NA
  } else {
    if (calculation == "min") {
      which(input_data == min(input_data, na.rm = TRUE))
    } else if (calculation == "max") {
      which(input_data == max(input_data, na.rm = TRUE))
    }
  }
}

# Mode
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}