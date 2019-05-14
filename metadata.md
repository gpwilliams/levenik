# Metadata

Note that due to excessive file sizes associated with storing Bayesian analyses in lists (and subsequently in .RData files), the outputs of data analyses are not hosted on GitHub, but are instead hosted on the OSF only on completion of the project.

There are 5 folders for this analysis:

## **01_materials**: contains /audio/, /images/, and /word_list/ folders:

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
    
Additionally contains a README.txt outlining some notes on the language and its construction.

## **02_data**:

Raw Data Files
=======================================================
PUT EXPLANATIONS HERE

reading_coding
reading_task
sessions
session_languages
writing_task

Cleaned Data Files
=======================================================
PUT EXPLANATIONS HERE

ex1_2_cleaned
ex1_2_filtered
ex1_2_filtered_subsetted

All contain demo.data and rw.data files

File Headings
=======================================================

All file headings are based on ex1_2_filtered
and ex1_2_filtered_subsetted 
(which share identical headings)

demo.data
---------

PUT EXPLANATIONS (AND DATA TYPE) TO THE SIDE OF EACH HEADING

participant_number
language_variety
orthography_condition
picture_condition
order_condition
speaker_condition
age
gender
language_spoken
language_proficiency_rating
fun_rating
noise_rating
start_timestamp
end_timestamp
total_time

rw.data
-------

PUT EXPLANATIONS (AND DATA TYPE) TO THE SIDE OF EACH HEADING 

trial_id
participant_number
session_trial_id
section_trial_id
task_trial_id
language_variety
orthography_condition
picture_condition
order_condition
speaker_condition
task
block
picture_id
word_id
test_words
dialect_words
target_length
exposure_count
target
primary_coder_response
primary_coder_response_length
primary_max_word_length
primary_coder_correct
primary_coder_nLED
secondary_coder_response
secondary_coder_response_length
secondary_max_word_length
secondary_coder_correct
secondary_coder_nLED
lenient_max_word_length
lenient_correct
lenient_nLED
stringent_max_word_length
stringent_correct
stringent_nLED
running_time

Please note that while the loading and saving of external files is executed using a relative file-path system, the ordering of files within each folder is necessary for the R scripts to run (i.e. do not move the data files from the data folder, or rename the folders and files). 

References

Rossion, B., & Pourtois, G. (2004). Revisiting Snodgrass and Vanderwart's object pictorial set: The role of surface detail in basic-level object recognition. Perception, 33(2), 217-236.

Forsythe, A., Street, N., & Helmy, M. (2017). Revisiting Rossion and Pourtois with new ratings for automated complexity, familiarity, beauty, and encounter. Behavior Research Methods, 1-10.