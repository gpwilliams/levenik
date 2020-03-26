# Metadata

Note that due to excessive file sizes associated with storing Bayesian analyses in lists (and subsequently in .RData files), the outputs of Bayesian data analyses are not hosted on GitHub. The folder structure is there to allow for these analyses to be conducted again to reproduce our results. Otherwise, please refer to the compressed version of the Bayesian analyses (in 03_analysis/02_main-analyses/04_output/06_all-results_compressed/).

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
            * trial_id: integers assigned to the trial being coded. Relates to trial_id in reading_task.csv and writing_task.csv.
            * session_number: integers assigned to a participant. Relates to session_number in reading_task.csv and writing_task.csv.
            * target: spelling for the written word on a given trial. Unidentifiable phonemes or diphthongs are represented by ? (diphthongs are not in the language). Missing trials or those unidentifiable as a result of technical errors are coded as \*. Some variations of ? and \* (e.g. ???) are in the raw data, but are standardised to single codes in the R scripts.
            * coded_response: the transcriber's interpretation of the spoken response.
            * correct: 0 = incorrect, 1 = correct.
            * edit_distance: length-normalised Levenshtein Edit distance (nLED). 0 = no insertions, deletions, or substitutions required to transform the coded_response to the target. Higher scores (up to 1) include some number of insertions, deletions, or substitutions to transform the coded_response to the target.
        * reading_task.csv:
            * trial_id: same interpretation as in reading_coding.csv.
            * timestamp: same interpretation as in reading_coding.csv.
            * session_number: same interpretation as in reading_coding.csv.
            * session_trial_id: the trial ID for a given participant (i.e. session_number).
            * section: section by which inputs are provided by the participant. These are prefixed by the task (R = Reading, W = Writing). Underscores separate the task by the block. For the training phase, these are defined as "TR" and appended with a number indicating block number. For the testing phase, these are simply defined as "TEST".
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

Please note that while the loading and saving of external files is executed using a relative file-path system, the ordering of files within each folder is necessary for the R scripts to run (i.e. do not move the data files from the data folder, or rename the folders and files). 

References

Rossion, B., & Pourtois, G. (2004). Revisiting Snodgrass and Vanderwart's object pictorial set: The role of surface detail in basic-level object recognition. Perception, 33(2), 217-236.

Forsythe, A., Street, N., & Helmy, M. (2017). Revisiting Rossion and Pourtois with new ratings for automated complexity, familiarity, beauty, and encounter. Behavior Research Methods, 1-10.