# Metadata

Note that due to excessive file sizes associated with storing Bayesian analyses in lists (and subsequently in .RData files), the outputs of Bayesian data analyses are not hosted on GitHub. Instead these can be found via the [OSF repository](https://osf.io/5mtdj/) in the folder **bayesian_analyses** with each model for each experiment saved under the appropriate subfolder. The Bayesian models will be produced when running the analysis code in R, and summaries of the models (i.e. with a reduced file size) are otherwise saved in in 03_analysis/04_output/04_all-results-compressed/all-results_compressed.RData.

The folder structure is there to allow for these analyses to be conducted again to reproduce our results. Otherwise, please refer to the compressed version of the Bayesian analyses (in 03_analysis/02_main-analyses/04_output/06_all-results_compressed/).

*Note that Experiments 1, 2a, 2b, and 3 in the paper are labelled Experiments 0, 1, 2, and 3 in the raw data and code.*

There are 5 folders for this analysis:

## **01_materials**: contains subfolders audio/, images/, and word_list/:

1. * **audio**: contains the /phonemes/ and /words/ folders
    * *phonemes*: .wav files of the individual phonemes used during exposure phases. These are coded using [CPSAMPA](http://clearpond.northwestern.edu/ipa_cpsampa.html). Files are appended by _male or _female indicating the speaker gender.
    * *words*: .wav files for the individual words used in the listening phases of the study. As with the phonemes these are appended with the speaker gender. Words are prefixed by their word ID and are spelled in CPSAMPA using their standard or dialect pronunciation where appropriate.

2. * **images**: contains /img/, /norms/ and /script/ folders.
    * *img*: contains the folders centred_subset and GIF-compressed_centred_subset:
        * centred_subset: numbered .png files taken from the Rossion & Pourtois colourised Snodgrass and Vanderwart picture set. These were centred on a 281 by 281 pixel white background. This was produced in GIMP.
        * GIF-compressed_centred_subset: GIF compressed subsets are the same images from centred_subset compressed into GIF files in GIMP.
    * *norms*: contains several sub-folders:
        * docs: picture_norms_report.pdf: contains a description of the images used in our study, including ratings such as category membership, image complexity, and agreement.
        * input: contains several data files providing norms for the images. These are split into the forsythe-et-al (ratings from Forsythe et al., 2017) and rossion-and-pourtois (ratings from Rossion & Pourtois, 2004) folders for published norms. The Forsythe et al. norms simply provide improvements on the ratings of the Rossion and Pourtois picture set. Additionally, our own norms are provided in williams-et-al_norms.csv. Finally subset.csv contains a list of the object ID and our own category for these objects taken from the Rossion and Pourtois picture set. 

        In all cases, item_number is the number of the item in the Rossion and Pourtois picture set, concept is the concept in the picture set, and PNG/GIF provide file sizes when using .png files or when compressed into .GIF files. GIF compression is a coarse measure of image complexity. Ratings for familiarity, encounter (how often people encounter each object), complexity (image complexity from participant ratings), GIF, and JPEG compression (which served a similar role to GIF compression) are provided in one .csv for a subset of items from Forsythe et al.. Similar ratings are provided in individual files from the Appendix of Rossion and Pourtois. These have been converted from the original .pdf to .csv files. Detailed explanations of all ratings are provided in picture_norms_report.pdf.

        * output: contains data files for combined ratings for the entire Rossion and Pourtois picture set in rossion-and-pourtois_cleaned.RDS, and for the subset used in this study in rossion-and-poirtois_cleaned_subset.RDS. Finally, means and standard deviations for all ratings for the subset of items are provided in subset_summary_statistics.csv.
        * R: contains numbered .R files for reading in file paths, preparing data, performing analyses, and creating the report contained in docs. 99_run-all performs all of this is one operation.

3. * **word_list**: contains a series of subfolders:
    * *docs*: contains word_ruleset_report.pdf: A detailed description of the rules used to produce the words in Levenik. Here, phonemes are represented using IPA characters.
    * *input*: contains a series of files:
        * CPSAMPA.csv: a description of the words used in the study and their phonological neighbourhood densities in English and Spanish. This was produced using the [CPSAMPA database](http://clearpond.northwestern.edu/). Contains the following headings:
            * item: item number.
            * pos_1-6: phoneme used in each letter position.
            * eng_word: the spelling in English (but with CPSAMPA-like capitalisation).
            * CPSAMPA: the full spelling for use in the CLEARPOND database.
            * structure: the syllable structure; C = consonant, V = vowel.
            * eng_total_ND: the total number of near neighbours in English.
            * spanish_total_ND: the total number of near neighbours in Spanish.
            * eng_neighbours: the near neighbours in English.
            * spanish_neighbours: the near neighbours in Spanish.
        * edit_distances.csv: contains length-normalised Levenshtein Edit Distances for each word against each other word.
        * phoneme_codes.csv: contains the IPA to CPSAMPA translation for each phoneme in the study. Additionally, gives the grapheme used to render the CPSAMPA codes during transcription.
        * spelling_and_pronunciations.csv*: contains the spellings and pronunciations of each word for transparent and opaque orthographies, as well as for contrastive and non-contrastive versions of the words. Additionally includes a code for whether a word is a testing word (testing_word: 1 = novel word appearing only during testing; 0 = trained word appearing in training and testing), contrastive, or non-contrastive (contrastive_word: 1 = contrastive, 0 = non-contrastive. This only applies to non-testing words). Finally contains a count of the number of phonemes that change in the contrastive words (phoneme_shift_count).
    * *output*: contains two files:
        * offset_consonant_count.csv: gives a count for the number of times two consonant offsets appear in the language.
        * onset_consonant_count.csv: gives a count of the number of times two consonant onsets appear in the language.
    * *R*: contains two files:
        * 01_word_ruleset.Rmd: Provides the R-markdown code for generating the .pdf found in docs.
        * 99_run-all.R: contains the code to render the R-markdown code found in 01_word_ruleset.Rmd, including loading of packages.
    
Additionally contains a README.txt with some notes on the language and its construction.

## **02_data**: contains subfolders 01_study-zero/, 02_study-one-and-two/, 03_study-three/, and 99_R-scripts/

1. * **01_study-zero**: contains 01_raw-data/, 02_merged-data, 03_cleaned-data/, 04_simulated-data/, and 05_data-checks/ subfolders:
    * *01_raw-data*: contains .csv files for the raw data gathered during the experiment. Note that recordings of spoken responses are not provided, but transcriptions of these files are provided in reading_coding.csv.
        * reading_coding.csv: transcriptions of spoken responses. Contains the following columns;
            * code_id: integers assigned to identify transcribed trials.
            * timestamp: timestamp of transcription in YMD-HMS format.
            * coder: name of the person who transcribed the trial.
            * trial_id: integers assigned to the trial being coded. Relates to trial_id in reading_task.csv (and writing_task.csv in later experiments).
            * session_number: integers assigned to a participant. Relates to session_number in reading_task.csv (and writing_task.csv in later experiments).
            * target: spelling for the written word on a given trial. Unidentifiable phonemes or diphthongs are represented by ? (diphthongs are not in the language). Missing trials or those unidentifiable as a result of technical errors are coded as \*. Some variations of ? and \* (e.g. ???) are in the raw data, but are standardised to single codes in the R scripts.
            * coded_response: the transcriber's interpretation of the spoken response.
            * correct: 0 = incorrect, 1 = correct.
            * edit_distance: length-normalised Levenshtein Edit distance (nLED). 0 = no insertions, deletions, or substitutions required to transform the coded_response to the target. Higher scores (up to 1) include some number of insertions, deletions, or substitutions to transform the coded_response to the target.
        * reading_task.csv:
            * trial_id: same interpretation as in reading_coding.csv.
            * timestamp: same interpretation as in reading_coding.csv.
            * session_number: same interpretation as in reading_coding.csv.
            * session_trial_id: the trial ID for a given participant (i.e. session_number).
            * section: section by which inputs are provided by the participant. These are prefixed by the task (R = Reading). Underscores separate the task by the block. For the training phase, these are defined as "TR" and appended with a number indicating block number. For the testing phase, these are simply defined as "TEST".
            * section_trial_id: the trial ID within a given section (e.g. training block 1 is defined as one section, block 2 is another section).
            * word_id: integers assigned to identify a given word. Relates to the word_id in word_list.csv.
            * novel_word_for_task: Defines whether or not a word has been seen/heard before for the participant during a given task.
            * exposure_count: tracks the number of times a participant has been exposed to a word as the trials progress.
            * picture_id: integers identifying the ID number associated with a picture associated with a word. Pictures are randomly assigned to words for each participant. This relates to the numbers associated with pictures in 01_materials/images/img/centred_subset. 
            * word_length: the number of letters in the given target.
            * target: same interpretation as in reading_coding.csv.
            * participant_input: the transcriber's most recent interpretation of the spoken response.
            * correct: same interpretation as in reading_coding.csv.
            * edit_distance: same interpretation as in reading_coding.csv.
        * sessions.csv: 
            * session_number: same interpretation as in reading_coding.csv.
            * progress: string indicating how far participants progressed in the experiment. END = completed the experiment, START = saw the beginning of the experiment (i.e. got past demographics and instructions). labels appended with INSTR_ indicate inter-stimulus sections. Exposure = word exposure phase. SCRIPT = instructions. Other labels relate to the block number outlined in the section column of reading_task.csv.
            * completion_code: unique completion code provided to participants only at the end of the experiment. Used only for verifying completion.
            * alphabet_key: string describing the associations between artificial letters and sounds. Each artificial letter is known by a numerical identifier (1-14) while sounds are represented in Latin letters. In alphabet_key, the 14 locations of each character represents 1 to 14 artificial letters, while the value of the character (Latin letter) represents the sound for that artificial letter. Every session gets randomly assigned letter to sound correspondences, hence the alphabet_key stores this information concisely.
            * language_condition: dialect = learners hear two different varieties (one during word exposure, one during learning); standard = learners hear one variety throughout.
            * order_condition: defines the task order. This is simply RR for this experiment, denoting that Reading training (blocks 1-3) is followed by another set of reading training (blocks 4-6).
            * picture_condition: defines whether (1) or not (0) a picture was present and associated with words during exposure, training, and testing phases.
            * speaker_condition: defines the speaker gender for the stimuli (female or male).
            * orthography_condition: defines whether the writing system was transparent (i.e. 1-to-1 mapping between sounds and phonemes) or opaque (i.e. conditional rules for spellings; see **01_materials**).
            * start_timestamp: datetime at which participants started the experiment (YMD-HMS).
            * end_timestamp: datetime at which participants completed the experiment (YMD-HMS).
            * age: age of the participant in years. Those who do not complete the task have not provided an age and thus default to 0.
            * gender: gender of the participant: m = male, f = female; o = other. Those who did not complete the experiment have no value for gender.
            * english: Likert rating from 1-5 for a self-rating of English proficiency; 1 is elementary proficiency and 5 is native or bilingual proficiency. Missing values (e.g. for non-completion) are assigned 0.
            * fun: Likert rating from 1-5 of the statement "I found the study fun." with 1 being "Strongly Disagree" and 5 being "Strongly Agree". Missing values (e.g. for non-completion) are assigned 0.
            * noise: Likert rating from 1-5 of the statement "I could hear the words in the study clearly." with 1 being Strongly Disagree and 5 being Strongly Agree. Missing values (e.g. for non-completion) are assigned 0.
        * sessions_languages.csv: 
            * input_id: integer determining at which order in the transcription a transcribed input was provided.
            * session_number: same interpretation as in reading_coding.csv.
            * language: String input provided by the participant outlining their languages spoken.
            * self_rating: Likert rating of proficiency in the self-reported language in the language column from 1-5 where 1 is elementary proficiency and 5 is native or bilingual proficiency.
        * word_list.csv: 
            * word_id: integer giving an ID for a given word.
            * word: spelling/pronunciation of the word using CPSAMPA notation.
            * dialect_version: pronunciation of the word in the "dialect" version of the language spoken during the exposure phase in the "dialect"/two-variety condition.
            * opaque_spelling: spelling of the word after adhering to the conditional rules for construction of the opaque language. This column is irrelevant for the transparent orthography condition.

    * *02_merged-data*: contains two .RData files; ex_0_merged.RData and ex_0_refactored.RData. Both data files are intemediary data produced prior to creation of the final cleaned data set used in analyses.
        * ex_0_merged: contains two data.frames, data and demo_data;
            * data: the raw data merged into one data.frame. This is restricted to test performance only and does not contain any demographic data. This contains most of the same columns from the raw data with the same meanings behind the column names and data types. However, here the transcriptions have been reduced to only those provided from "glenn" and "vera", who take the primary coder and secondary coder labels. The most recent transcriptions from each has been taken (i.e. allowing for correction of erroneous submissions) and the transcription, transcribed word length, whether or not the transcribed word was correct, and the nLED for the transcribed word and target are provided. These columns take the form of primary_coder/secondary_coder appended to _response, _response_length, _correct, and _nLED respectively. Note that not all columns are in the correct data types at this stage (e.g. nLED columns are characters).
            * demo_data: demographics for participants that took part in the experiment. Here all columns are as described in the raw data section.
        * ex_0_refactored: contains two data.frames, data and demo_data;
            * data: contains the same data as in the ex_0_merged data.frame, data, but has all columns with their correct data type. Additionally includes the columns prefixed with lenient_ and stringent_. These provide the "lenient" and "stringent" coding schemes, taking either the the most forgiving transcription (i.e. lowest nLED; when nLED matches, the fewest number of letters) of the primary and secondary coder's transcriptions, or the harshest transcription (i.e. highest nLED; when nLED matches, the highest number of letters). lenient/stringent_max_word_length provides maximum number of letters between the target and transcription, _nLED gives the nLED, and _correct states whether or not a transcribed response was correct. Both nLED and correct data types have the same interpretation as before. 
                * submission_time: determines the time between trials in seconds; class Duration in the R-package lubridate.
                * running_time: determines the time from starting the experiment and submitting an individual trial; class Duration in the R-package lubridate.
            * demo_data: contains the same columns and data as with the ex_0_merged demo_data, but with all columns using the correct data type.
    
    * *03_cleaned-data*: contains 3 .RData files: ex_0_cleaned.RData, ex_0_filtered.RData, and ex_0_filtered_subsetted.RData.
        * ex_0_cleaned.RData: contains two data.frames; data and demo_data:
            * data: the cleaned data from the experiment with the following columns:
                * trial_id: integer counting the trial ID from 1 until the final trial of the experiment across all participants.
                * participant_number: unique integer for indentifying each participant.
                * session_trial_id: integer counting the trial ID within each participant from 1 until the end of their session (typically 102 in Experiment 0).
                * language_variety: factor identifying the language variety taught to each participant with 2 levels; dialect (i.e. variety mismatch) and standard (i.e. variety match).
                * orthography_condition: factor identifying the consistency of the orthography taught to participants with 2 levels; transparent (i.e. consistent) or opaque (i.e. inconsistent).
                * picture_condition: factor identifying whether or not participants saw pictures while learning words with 2 levels; picture or no picture.
                * order_condition: factor identifying the order or presentation of training and testing blocks with 1 level; RR (i.e. reading followed by a repeated reading block).
                * speaker_condition: factor identifying the gender of the speaker with 2 levels; male or female.
                * task: factor identifying the task for each trial; R (i.e. reading).
                * block: factor with 7 levels; TR1 through to TR6 (i.e. training blocks 1 through 6) and TEST (i.e. the testing block).
                * picture_id: integer identifying the picture used for each word for a given trial. These are randomly allocated to words across participants. These numbers map onto the IDs given to images stored in materials/images/img/centred_subset.
                * word_id: iteger identifying the word for a given trial. These numbers map onto the nubers prepended to the audio files in materials/audio/words.
                * test_words: factor identifying whether or not a word is a testing word with 2 levels; training_word (i.e. appearing in training and testing phases) and testing_word (i.e. only appearing in the testing phase).
                * dialect_words: factor identifying the type of word for a given trial with 3 levels; shifted_word (i.e. a word with a dialect variant), no_shift_word (i.e. a  word without a dialect variant), and can_shift_word (i.e. words that using our ruleset could be a dialect word, but only appear during testing; these are always testing_words).
                * target_length: iteger for the number of letters in the target word for a given trial.
                * exposure_count: integer for how many times a participant has seen the word trial to the given trial.
                * target: string using CPSAMPA coding identifying the target word participants should produce for a given trial either.
                * primary_coder_response: string using CPSAMPA coding identifying the the transcription of the audio data or a recording of the written input from participants. These inputs can only vary across coders in the reading task due to individual variation in transcription.
                * primary_coder_response_length: integer for the number of letters in the primary_coder_response.
                * primary_max_word_length: integer getting the maximum number between the target_length and primary_coder_response_length. This is used to calculate length-normalised Levenshtein Edit Distances.
                * primary_coder_correct: binary value indicating whether the primary_coder_response matches the target; 0 = no match, 1 = perfect match.
                * primary_coder_nLED: numeric value between 0 and 1 for the length-normalised Levenshtein Edit distance for the difference between the target and the primary_coder_response; values of 0 indicate a perfect match and 1 indicate all letters require insertion, substitution, or deletion. Values between 0 and 1 indicate different levels of "correctness", with low values indicating a closer match between strings.
                * secondary_coder_response, secondary_coder_response_length, seconary_max_word_length, secondary_coder_correct, and secondary_coder_nLED: all have the same meanings as their counterparts prepended with "primary" but this time for the secondary coder.
                * lenient_max_word_length: integer for the lowest value between primary_coder_response_length and secondary_coder_response length (i.e. used in computing lenient-coded Levenshtein Edit Distances). All lenient measures penalise errors the least assuming the best-fitting transcription for a given trial and the target across coders.
                * lenient_correct: numeric value the highest value between primary_coder_correct and secondary_coder_correct.
                * lenient_nLED: numeric value for the lowest value between primary_coder_nLED and secondary_coder_nLED.
                * stringent_max_word_length, stringent_correct, and stringent_nLED all have similar meanings their lenient counterparts but this time coding penalises input so the biggest difference between participant input and the target is used in calculating statistics. So, stringent_max_word_length takes the highest value between primary_max_word_length and secondary_max_word_length, stringent_correct takes the lowest value between primary_coder_correct and secondary_coder_correct, and stringent_nLED takes the highest value between primary_coder_nLED and secondary_coder_nLED.
                * submission_time: duration from the beginning of the experiment until the given trial indicating how long has elapsed for each participant; class Duration in the R-package lubridate.
                * running_time: duration from the previous to the current trial for each participant; class Duration in the R-package lubridate. The first trial is always NA.
                
            * demo_data: the demographics for each participant.
                * participant_number: unique integer for indentifying each participant across data sets.
                * language_variety: factor identifying the language variety taught to each participant with 2 levels; dialect (i.e. variety mismatch) and standard (i.e. variety match).
                * orthography_condition: factor identifying the consistency of the orthography taught to participants with 2 levels; transparent (i.e. consistent) or opaque (i.e. inconsistent).
                * picture_condition: factor identifying whether or not participants saw pictures while learning words with 2 levels; picture or no picture.
                * order_condition: factor identifying the order or presentation of training and testing blocks with 1 level; RR (i.e. reading followed by a repeated reading block).
                * speaker_condition: factor identifying the gender of the speaker with 2 levels; male or female.
                * age: integer for age in years for each participant.
                * gender: factor identifying the input by a given participant for their gender with 4 levels: "" (i.e. no input), "f" (i.e. female), "m" (i.e. male), and "o" (i.e. other).
                * language_spoken: character identifying which languages the participant knows (e.g. English, Spanish, Japanese).
                * language_proficiency_rating: Likert scale from 1 (elementary) to 5 (native or native-like) proficiency in the language indicated by the participant.
                * fun_rating: Likert scale from 1 (low enjoyment) to 5 (high enjoyment) for how fun the participants found the experiment.
                * noise_rating: Likert scale for how well participants could hear words in the study; "I could hear the words in the study clearly." from 1 (strongly disagree) to 5 (strongly agree).
                * start_timestamp: POSIXct for the datetime at which the study was started in YYYY-MM-DD, HH-MM-SS format.
                * end_timestamp: POSIXct for the datetime at which the study was ended in YYYY-MM-DD, HH-MM-SS format.
                * total_time: total time spent on the experiment: class Duration from the lubridate R package.
        
        * ex_0_filtered.RData: The same data.frames and columns within data frames are within the filtered data, however, participants who had technical difficulties with the experiment were excluded from these data sets. These exlusions are listed as "technical_difficulty" in the group column of the dropped_participants_and_reasons.csv file in 02_data/01_study-zero/05_data-checks. **Note that this is the data set used to fit models in final analyses and thus in the paper**.
        * ex_0_filtered_subsetted.RData: The same data.frames and columns within data frames are within the filtered data, however, participants who had technical difficulties with the experiment or who were showed poor performance in number of data checks were excluded from these data sets. These exlusions are listed as "performance" in the group column of the dropped_participants_and_reasons.csv file in 02_data/01_study-zero/05_data-checks.
        
    * *04_simulated-data*: contains one .csv file, ex_0_simulated_nLED.csv, generated from the simulate_random_input.R file in the 02_data/99_R-scripts folder.
        * ex_0_simulated_nLED.csv: file containing 3 columns associated with the performance of the simulation when attempting to match 2 strings based on randomly selecting letters (from the 13 letters used to make up the words in the materials) and comparing these against the total number of words given to participants in the testing phase of the experiment (i.e. 42 words here). These nLEDs are then used to guage what performance is like when participants input random letters. Contans the following columns:
            * iteration: integer for the iteration in the simulation.
            * nLED: numeric value for the average nLED calculated for a given iteration.
            * type: character for the method used to generate random input; can be "random_letter" or "random_word" evaluating to randomly selecting letters to produce a string, or randomly selecting a whole word from the word inventory and matching these against targets.
            
    * *05_data-checks*: contains 13 files which perform checks of the data using the R-files 04_simulate_random_input.R, 05_participant_filtering.R, 06_list_counts.R, 07_performance_plots.R, and 08_cross_coding_checks.R in the 02_data/99_R-scripts folder:
        * ex_0_dropped_participants_and_reasons.csv: table of containing participant_number, reason, and group headings, denoting the ID of any participants dropped from the data sets, along with reasons for the exclusions, and a group for the reasons denoting whether these participants are excluded for technical issues or performance issues. Technical issues are excluded from the data in 02_data/03_cleaned-data/ex_0_filtered.RData which is used for the final analysis. Those with either technical or performance issues are excluded in 02_data/03_cleaned-data/ex_0_filtered_subsetted.RData.
        * ex_0_dropped_trials.txt: text file containing two columns, partcipant and total_trials_from_max which note the participant ID of any participants with missing trials and how many trials they have to be compared against the maximum number possible (e.g. 102 in this experiment).
        * ex_0_duplicates.txt: text file containing four columns used to identify any participants with duplicate observations due to server issues. This contains participant_number, orthography_condition, and language_varieyt columns which have the same meaning as in the full data, and a column, count, which counts the number of duplicate trials. If blank (as it is here) then no duplicates have been detected.
        * ex_0_list_counnts.txt: a text file with a count of how many participants are in each combination of orthography_condition, language_variety, picture_condition, order_condition and speaker_condition. These should be balanced across participants after removing any participants due to technical issues.
        * ex_0_participant_coder_ID_check.csv: a table tracking how many trials have been coded for each participant by each coder. This tracks the participant_number, orthography_condition, and how many trials have been coded by the primary and secondary coder in the primary_coded and secondary_coded columns. The total number of trials which need to be coded is tracked in N_trials.
        * ex_0_participant_means_based_on_reading_data.csv: a table tracking means performance across all trials from the testing block. This file is used to filter participants based on performance to produce 02_data/03_cleaned-data/ex_0_filtered_subsetted.RData using the 02_data/99_R-scripts/05_participant_filtering.R file. This table contains participant_number and orthography_condition which have the same meaning as in the full data, along with mean_nLED (mean based on nLED), sd_nLED (sd based on nLED), and median_submission_time, and total_time which track how long participants took on average across trials, and how long they took on the experiment as a whole.
        * ex_0_sub_list_counts.txt: This has the same information as ex_0_list_counnts.txt but is based on only the participants remaining after removal based on both technical difficulties and performance-based measures in 02_data/99_R-scripts/05_participant_filtering.R.
        * ex_0_subjects_and_items_to_code.csv: a table containing coder, participant_number, and trial_number headings giving details of how many participants still need to be transcribed for each coder split by item. If this is blank, no participants remain to be transcribed. This is produced by the 02_data/99_R-scripts/08_cross_coding_checks.R file.
        * ex_0_subjects_to_code.csv: This has the same information as ex_0_subjects_and_items_to_code.csv but excludes the trial counts (for ease of reading when many trials remain). This is produced by the 02_data/99_R-scripts/08_cross_coding_checks.R file.
        * ex_0_target_lag_strategy.csv: this explores the possibility of participants producing the previous target on the current trial to make it seem as though performance is based on learning some words from the lexicon. This contains the columns participant_number, session_trial_id, target, primary_coder_response, and secondary_coder_response that have the same meanings as the full data, and the additional column target_lag that gives the target for the previous trial. Participants with many observations here are likely to be using a lagging strategy.
        * ex_0_task_means.txt: this has the same information as the ex_0_participant_means_based_on_reading_data.csv but also splits the statistics by task for cases where two tasks are present.
        * ex-0_lenient_nLED.pdf: plot produced from 02_data/99_R-scripts/07_participant_performance_plots.R which splits panels into individual participant numbers and tracks performance (in nLED) across trials over time. Those with average performance below the simulations are highlighted in red.
        * ex-0_target-distances.pdf: plot produced from 02_data/99_R-scripts/07_participant_performance_plots.R which splits panels into individual participant numbers and tracks how far away participants inputs were from the target input in terms of absolute character length across trials over time. Those with average performance below the simulations are highlighted in red.
        
2. * **02_study-one-and-two**: contains the same sub-folders and the same contents within these folders in relation to **01_study-zero** with the addition of data related to the writing/spelling task. Here, additional files not found in **01_study-zero** are described:      
    * *01_raw-data*: contains .csv files for the raw data gathered during the experiment.
        * writing_task.csv:
                * trial_id: same interpretation as in reading_coding.csv.
                * timestamp: same interpretation as in reading_coding.csv.
                * session_number: same interpretation as in reading_coding.csv.
                * session_trial_id: the trial ID for a given participant (i.e. session_number).
                * section: section by which inputs are provided by the participant. These are prefixed by the task (W = Writing). Underscores separate the task by the block. For the training phase, these are defined as "TR" and appended with a number indicating block number. For the testing phase, these are simply defined as "TEST".
                * section_trial_id: the trial ID within a given section (e.g. training block 1 is defined as one section, block 2 is another section).
                * word_id: integers assigned to identify a given word. Relates to the word_id in word_list.csv.
                * novel_word_for_task: Defines whether or not a word has been seen/heard before for the participant during a given task.
                * exposure_count: tracks the number of times a participant has been exposed to a word as the trials progress.
                * picture_id: integers identifying the ID number associated with a picture associated with a word. Pictures are randomly assigned to words for each participant. This relates to the numbers associated with pictures in 01_materials/images/img/centred_subset. 
                * word_length: the number of letters in the given target.
                * target: same interpretation as in reading_coding.csv.
                * participant_input: the transcriber's most recent interpretation of the spoken response.
                * correct: same interpretation as in reading_coding.csv.
                * edit_distance: same interpretation as in reading_coding.csv.
    * *02_merged-data*: contains two files, ex_1_2_merged.RData and ex_1_2_refactored.RData. These files have the same column headings and data labels as their counterparts in **01_study-zero**. Here, the task column can take two values (R = Reading, W = Writing) corresponding to which task was used to generate the data. Additionally, the two experiments are identified by their orthography (under the column, orthography_condition): "transparent" refers to the experiment conducted with a transparent/consistently orthography, Experiment 1 (labelled Experiment 2a in the paper), while "opaque" refers to the experiment conducted with an opaque/inconsistent orthography, Experiment 2 (labelled Experiment 2b in the paper). 
    * *03_cleaned-data*: contains the same files as their counterparts in **01_study-zero**. Column headings and data labels have the same meanings as in **01_study-zero** again with the addition of the changes to the task and orthography_condition columns identified in *02_merged-data* above for these experiments.
    * *05_data-checks*: contains the same files as in **01_study-zero** with the exception that plots exploring the lenient_nLED over time split by participants (files ending in _lenient_nLED.pdf) and absolute mismatches in target and input letter length (files ending in _target-distances.pdf) are split by Experiments 1 and 2.
    
3. **03_study-three**: all subfolders and files have the same meanings as those outlined for **02_study-one-and-two**. However, here the training task was extended, resulting in 6 blocks of training in the training task.

4. **99_R-scripts**: contains 11 .R files, 00_refactoring_functions.R, 01_data_merging.R, 02_data_refactoring.R, 03_data_cleaning.R, 04_simulate_random_input.R, 05_participant_filtering.R, 06_list_counts.R, 07_participant_performance_plots.R, 99_run_all.R, and remove_personal_info.R. The numbered files typically use conditionals to perform slightly different operations across experiment (e.g. attempting to not merge with any writing data for Experiment 0 as this file does not exist). These files are explained below:
    * *00_refactoring_functions*: contains 3 documented functions used for refactoring data which are not available to base R.
    * *01_data_merging.R*: reads in the raw data files and prepares individual data.frames for merging together into the separate experimental data (data) and demographic data (demo_data) saved into the /02_merged-data/ subfolder in the .RData files ending in _merged.RData. Here filtering of the data occurs to remove any participants who did not complete the experiment and any dummy runs we performed during testing.
    * *02_data_refactoring.R*: generates new columns based on operations on the existing data (e.g. producing lenient and stringent outcomes based on both coder's inputs) and reorders columns. Produces the two additional columns in the data data.frame, test_words and dialect_words, described in the 03_cleaned-data subsections. data and demo_data are saved into the /02_merged-data/ subfolder in the .RData files ending in _refactored.RData.
    * *03_data_cleaning.R*: makes consistent codes for missing/uninterpretble inputs in the data data.frame, saved to the /03_cleaned-data/ subfolder in the files ending in _cleaned.RData. Also checks for duplicate trials in the data, saved to the /05_data_checks/ subfolder in the .txt files ending in _duplicates.txt.
    * *04_simulate_random_input.R*: simulates performance for a participant either inputting random strings made up of individual letters or from guessing whole words (type = "random_letter" or type "random_word"). Files are saved in the /04_simulated-data/ subfolder in the files ending in _simulated_nLED.csv.
    * *05_participant_filtering.R*: identifies issues with individual participant responses based on technical difficulties (e.g. missing trials, unidentifiable audio) and/or performance-based reasons (e.g. exceptionally-high error rates vs. simulated input identified in files ending in _simualted_nLED.csv in the /04_simulated-data/ subfolder, using a target lag strategy [see above]). Files are saved as:
        * *data checks* in the subfolder /05_data-checks/:
            * *participant means and input letter distance from the target*: files ending in participant_means_based_on_reading_data.txt (note this can vary if a user sets the participant_means_basis to be based on writing or both tasks together).
            * *participant means and input letter distance from the target split across tasks*: files ending in _task_means.txt.
            * *number of dropped trials split by participant*: files ending in _dropped_trials.txt.
            * *participants and trials with a target lagging strategy during training*: files ending in _target_lag_strategy.csv.
        * *dropped participants (and reasons why)* in the subfolder /05_data-checks/: contains one file ending in _dropped_participants_and_reasons.csv which outlines reasons for dropping participants from analysis. Details of the exclusion criteria are outlined in *03_cleaned-data* above.
        * *data filtered to only those without technical difficulties (used for final analysis) and only those without technical difficulties or highlighted issues with performance*: files saved to the subfolder /03_cleaned-data/ ending in _filtered.RData and _filtered_subsetted.RData respectively. Details of these files are highlighted in *03_cleaned-data* above.
    * *06_list_counts.R*: counts the number of participants within each list of the experiment for the final filtered data and for the files in the /03_cleaned-data/ folder ending in _filtered.RData and _filtered_subsetted.RData. This information is saved in the /05_data-checks/ subfolder in the files ending in _list_counts.txt and _sub_list_counts.txt respectively.
    * *07_participant_performance_plots.R*: generates the target distance and overall performance plots saved in the /05_data-checks/ folder ending in _target-distances.pdf and _lenient_nLED.pdf respectively. Details of these plots are highlighted in *05_data-checks* above.
    * *08_cross_coding_checks.R*: identifies which participants have been transcribed, including item counts by coders, identifies participants with items still to be transcribed, and particiants and the particular items within participants that still need to be transcribed. This is particularly useful for identifying missing transcriptions during the transcription process. Files are saved in the /05_data-checks/ folder in the files ending in _participant_coder_ID_check.csv, _subjects_to_code.csv, and _subjects_and_items_to_code.csv respectively. Details of these plots are highlighted in *05_data-checks* above.
    * *99_run_all.R*: runs all R files in this folder (excluding remove_personal_info.R) for each experiment, producing all outputs highlighted above. This essentially prepares the data and provides all data checks necessary for each experiment prior to plotting of descriptive statistics and full analysis.
    * *remove_personal_info.R*: checks that all raw data loaded into the /01_raw-data/ file within each study folder does not contain any personal information, effectively removing information such as browser type and or ID codes from online testing environments. This is just saved here to show how data were anonymised to meet GDPR guidelines. This came into effect prior to Experiment 3, which explains why no anonymisation is needed here as this data was never stored on the server during testing.
        
## **03_analysis**: contains subfolders /01_cross-coding/, /02_main-analyses/, /03_model_checks/, /04_demographic_checks/ and /05_exploratory-analysis/:       

1. * **01_cross-coding** contains the subfolders /output/ and /R/:
    * *R*: contains the files 01_prepare-data.R, 02_analysis.R, 03_missing-checks.R, and run_all.R used to perform analyses relating to the consistency in transcription across coders:
        * 01_prepare-data.R: 
        
        
    

Please note that while the loading and saving of external files is executed using a relative file-path system, the ordering of files within each folder is necessary for the R scripts to run (i.e. do not move the data files from the data folder, or rename the folders and files). 





 RW (ri.e. eading followed by writing), or WR (i.e. writing followed by reading)
 
 
 

References

Rossion, B., & Pourtois, G. (2004). Revisiting Snodgrass and Vanderwart's object pictorial set: The role of surface detail in basic-level object recognition. Perception, 33(2), 217-236.

Forsythe, A., Street, N., & Helmy, M. (2017). Revisiting Rossion and Pourtois with new ratings for automated complexity, familiarity, beauty, and encounter. Behavior Research Methods, 1-10.