# Data Preparation for NHST & Bayesian Analyses ----

# Makes polynomials

# make orthogonal polynomial time term for training
if (experiment == 0 | experiment == 3) {
  # 6 blocks; linear and quadratic orthogonal time terms (ot1/ot2)
  polynomials <- poly(1:max(training$block_num), 2)
  training[, paste0("ot", 1:2)] <- polynomials[training$block_num, 1:2]
} else if (experiment > 0) {
  # 3 blocks; linear orthogonal time term (ot1) only
  polynomials <- poly(1:max(training$block_num), 1)
  training$ot1 <- polynomials[training$block_num, 1]
}