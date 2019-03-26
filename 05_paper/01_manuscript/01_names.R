interaction_terms <- c(
  "ot1" = "B",
  "ot2" = "B$\\^2$",
  "poly\\(block_num, 1\\)" = "B",
  "poly\\(block_num, 2\\)1" = "B",
  "poly\\(block_num, 2\\)2" = "B$\\^2$",
  "language_variety1" = "VC",
  "picture_condition1" = "PC",
  "task1" = "TC",
  "language_varietystandard" = "VMa",
  "language_varietydialect" = "VMis",
  "picture_conditionpicture" = "P",
  "picture_conditionno_picture" = "NP",
  "dialect_words1" = "WT",
  "dialect_words2" = "WF",
  "taskR" = "R",
  "taskW" = "S",
  ":" = " $\\\\times$ " # 4 escapes properly in kableExtra
)

main_terms <- c(
  "\\(Intercept\\)" = "Intercept",
  "ot1" = "Block",
  "ot2" = "Block$\\^2$",
  "poly\\(block_num, 1\\)" = "Block",
  "poly\\(block_num, 2\\)1" = "Block",
  "poly\\(block_num, 2\\)2" = "Block$\\^2$",
  "language_variety1" = "Variety Condition",
  "picture_condition1" = "Picture Condition",
  "task1" = "Task"
)

shared_colnames <- list(
  "Term", 
  "$Est.$", 
  "$SE$", 
  "95\\% Conf. I", 
  "$t$", 
  "$p$",
  "$Est.$",
  "$SE$", 
  "95\\% Cred. I"
)