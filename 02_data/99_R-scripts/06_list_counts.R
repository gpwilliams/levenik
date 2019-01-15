###############################################################################
# list counts and dropped trials counts
###############################################################################
# Description
#
#
###############################################################################

# Load data
############

load(paste0(
  "../",
  folder,
  "/03_cleaned-data/",
  experiments,
  "_filtered.Rdata"
))

dropped_participants <- read.csv(
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_dropped_participants_and_reasons.csv"
  ),
  stringsAsFactors = F
)

duplicates <- read.table(
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_duplicates.txt"
  ),
  stringsAsFactors = F
)

###############################################################################
# total counts per list: which ones have been tested, and by how many subjects?

# copy demo_data; make wide format
wdemo_data <- demo_data %>%
  spread(language_spoken, language_proficiency_rating)

technical_drops <- dropped_participants %>%
  filter(group == "technical_difficulty")

# dropping those with technical difficulties
list_counts <- wdemo_data %>%
  subset(
    !participant_number %in%
      technical_drops$participant_number
    ) %>%
  group_by(
    orthography_condition,
    language_variety,
    picture_condition,
    order_condition,
    speaker_condition
  ) %>%
  summarise(count = length(language_variety))

# list counts after also removing low performing participants
sub_list_counts <- wdemo_data %>%
  subset(!participant_number %in%
    dropped_participants$participant_number) %>%
  group_by(
    orthography_condition,
    language_variety,
    picture_condition,
    order_condition,
    speaker_condition
  ) %>%
  summarise(count = length(language_variety))

###############################################################################
# outputs
###############################################################################

# save text files for tests
###########################

# list counts prior to filtering low performing participants
write.table(
  list_counts,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_list_counts.txt"
  )
)

# list counts after filtering low performing participants
write.table(
  sub_list_counts,
  paste0(
    "../",
    folder,
    "/05_data-checks/",
    experiments,
    "_sub_list_counts.txt"
  )
)