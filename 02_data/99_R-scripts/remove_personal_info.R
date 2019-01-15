# anonymises data prior to pushing to github
library(dplyr)

# study 0
# removes columns containing personally identifying information
anonymised <- read.csv("../01_study-zero/01_raw-data/sessions.csv") %>%
  select(-prolific_id, -prolific_session, -browser)

# overwrites sessions.csv
write.csv(anonymised, "../01_study-zero/01_raw-data/sessions.csv")

# study 1 and 2
# removes columns containing personally identifying information
anonymised <- read.csv("../02_study-one-and-two/01_raw-data/sessions.csv") %>%
  select(-prolific_id, -prolific_session, -browser)

# overwrites sessions.csv
write.csv(anonymised, "../02_study-one-and-two/01_raw-data/sessions.csv")