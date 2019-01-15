#define letters and words
letters <- c(
  "a", 
  "E", 
  "i", 
  "O", 
  "u", 
  "m", 
  "n", 
  "b", 
  "d", 
  "k", 
  "f", 
  "s", 
  "l"
)

trainingWords <- c(
	'fub',
	'nEf',
	'mif',
	'nal',
	'lOm',
	'daf',
	'snid',
	'snOf',
	'blim',
	'blaf',
	'flOb',
	'balf',
	'mOls',
	'fOns',
	'nifs',
	'nEsk',
	'nOflE',
	'dEsna',
	'dasmu',
	'kublE',
	'bEsmi',
	'smiba',
	'skEfi',
	'smadu',
	'flidu',
	'slOku',
	'blEkus',
	'snibOl',
	'flEsOd',
	'slinab'
)

testingWords <- c(
	'mab',
	'skub',
	'klEb',
	'dOlk',
	'suld',
	'dikla',
	'luskO',
	'klufE',
	'klOda',
	'skOnEf',
	'klusim',
	'flabun'
)

# ----------------------------------
# SIMULATION 1: RANDOM STRINGS
# ----------------------------------

# generate a word of a particular length
generateRandomWord <- function(word, length, withReplacement) {
  word <- paste(
    sample(letters, length, replace = withReplacement),
    collapse = ""
  )
}

# attempt to guess a given word
attemptWord <- function(word, withReplacement) {

	# generate word
	attempt <- generateRandomWord(word, nchar(word), withReplacement)

	# compute edit distances
	editDistance <- as.vector(adist(attempt, word)/nchar(word))
}

# simulate output of one participant
simulateParticipantOutput <- function() {
	result <- sapply(c(
	  trainingWords, 
	  trainingWords, 
	  testingWords
	  ), 
	  attemptWord, 
	  withReplacement = FALSE
	  )
}

# simulate output of one participant and return its mean
simulateParticipantOutputMean <- function(result) {
	result <- mean(simulateParticipantOutput())
}

# do simulations
results_sim_1 <- sapply(1:1000, simulateParticipantOutputMean)
mean(results_sim_1)

# ----------------------------------
# SIMULATION 2: WHOLE WORD GUESS
# ----------------------------------

# pick a word of a particular length
pickRandomWholeWord <- function(length) {
	if (length == 3)
		sample(trainingWords[1:6], 1)
	else if (length == 4)
		sample(trainingWords[7:16], 1)
	else if (length == 5)
		sample(trainingWords[17:26], 1)
	else if (length == 6)
		sample(trainingWords[27:30], 1)
}

# attempt to guess a given word
attemptWholeWord <- function(word) {

	# pick word
	attempt <- pickRandomWholeWord(nchar(word))

	# compute edit distances
	editDistance <- as.vector(adist(attempt, word)/nchar(word))
}

# simulate output of one participant
# add additional training words to include training block
simulateParticipantOutputWholeWord <- function() {
	result <- sapply(c(trainingWords, testingWords), attemptWholeWord)
}

# simulate output of one participant and return its mean
simulateParticipantOutputMeanWholeWord <- function(result) {
	result <- mean(simulateParticipantOutputWholeWord())
}

# do simulations
n_sim <- 1000
results_sim_2 <- sapply(1:n_sim, simulateParticipantOutputMeanWholeWord)

#save results
# make df
results_sim_1 <- data.frame(
  "iteration" = rep(1:n_sim),
  "nLED" = results_sim_1,
  "type" = "random_letter"
)

results_sim_2 <- data.frame(
  "iteration" = rep(1:n_sim),
  "nLED" = results_sim_2,
  "type" = "random_word"
)

results <- rbind(results_sim_1, results_sim_2)

# output
write.csv(
  results,
  paste0(
    "../",
    folder,
    "/04_simulated-data/",
    experiments,
    "_",
    "simulated_nLED.csv"
  )
)