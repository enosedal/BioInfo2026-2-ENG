#!/usr/bin/env Rscript

# =========================================================
# Classical Statistics for Biological Data
# Module 06 - Statistics for Biological Data
# UNAM ENES Juriquilla
# Efrén Nosedal González
# =========================================================

cat("==========================================\n")
cat("Starting Classical Statistics Analysis\n")
cat("==========================================\n")

# =========================================================
# Package Loading and Validation
# =========================================================

required_packages <- c(
  "pwr",
  "rpart"
)

for(pkg in required_packages){

  if(!require(pkg, character.only = TRUE)){

    install.packages(pkg,
                     repos = "https://cloud.r-project.org")

    library(pkg,
            character.only = TRUE)
  }
}

# =========================================================
# Output Directory Validation
# =========================================================

if(!dir.exists("../figures")){

  dir.create("../figures",
             recursive = TRUE)
}

# =========================================================
# Section 1: Wilcoxon Rank Sum Test
# =========================================================

cat("[1/6] Running Wilcoxon Test...\n")

control <- c(5, 6, 7, 5, 6)
treated <- c(9, 10, 8, 9, 11)

wilcox_results <- wilcox.test(
  control,
  treated
)

print(wilcox_results)

# =========================================================
# Section 2: Kruskal-Wallis Test
# =========================================================

cat("[2/6] Running Kruskal-Wallis Test...\n")

group <- factor(c(
  rep("A", 5),
  rep("B", 5),
  rep("C", 5)
))

values <- c(
  5, 6, 7, 5, 6,
  8, 9, 10, 9, 11,
  12, 13, 14, 13, 15
)

kruskal_results <- kruskal.test(
  values ~ group
)

print(kruskal_results)

# =========================================================
# Section 3: Permutation Test
# =========================================================

cat("[3/6] Running Permutation Test...\n")

observed_difference <-
  mean(treated) -
  mean(control)

all_data <- c(
  control,
  treated
)

labels <- c(
  rep("control", 5),
  rep("treated", 5)
)

permuted_differences <- numeric(10000)

set.seed(123)

for(i in 1:10000){

  shuffled_labels <- sample(labels)

  permuted_differences[i] <-
    mean(all_data[shuffled_labels == "treated"]) -
    mean(all_data[shuffled_labels == "control"])
}

permutation_pvalue <-
  mean(
    abs(permuted_differences) >=
      abs(observed_difference)
  )

cat("\nObserved Difference:\n")
print(observed_difference)

cat("\nPermutation p-value:\n")
print(permutation_pvalue)

png(
  "../figures/permutation_test.png",
  width = 1200,
  height = 900
)

hist(
  permuted_differences,
  main = "Null Distribution by Permutation",
  xlab = "Difference of Means"
)

abline(
  v = observed_difference,
  lwd = 3
)

dev.off()

# =========================================================
# Section 4: Correlation Analysis
# =========================================================

cat("[4/6] Running Correlation Analysis...\n")

pearson_correlation <-
  cor(
    mtcars$wt,
    mtcars$mpg,
    method = "pearson"
  )

spearman_correlation <-
  cor(
    mtcars$wt,
    mtcars$mpg,
    method = "spearman"
  )

kendall_correlation <-
  cor(
    mtcars$wt,
    mtcars$mpg,
    method = "kendall"
  )

cat("\nPearson Correlation:\n")
print(pearson_correlation)

cat("\nSpearman Correlation:\n")
print(spearman_correlation)

cat("\nKendall Correlation:\n")
print(kendall_correlation)

png(
  "../figures/correlation_plot.png",
  width = 1200,
  height = 900
)

plot(
  mtcars$wt,
  mtcars$mpg,
  main = "Vehicle Weight vs Fuel Efficiency",
  xlab = "Weight",
  ylab = "Miles per Gallon"
)

abline(
  lm(mpg ~ wt,
     data = mtcars),
  lwd = 3
)

dev.off()

# =========================================================
# Section 5: Statistical Power Analysis
# =========================================================

cat("[5/6] Running Power Analysis...\n")

power_results <- pwr.t.test(
  d = 0.8,
  power = 0.8,
  sig.level = 0.05,
  type = "two.sample"
)

print(power_results)

# =========================================================
# Section 6: Decision Tree Analysis
# =========================================================

cat("[6/6] Running Decision Tree Analysis...\n")

decision_tree_model <- rpart(
  Species ~ .,
  data = iris,
  method = "class"
)

png(
  "../figures/decision_tree.png",
  width = 1200,
  height = 900
)

plot(
  decision_tree_model,
  uniform = TRUE,
  margin = 0.1
)

text(
  decision_tree_model,
  use.n = TRUE,
  cex = 0.8
)

dev.off()

# =========================================================
# Final Summary
# =========================================================

cat("\n==========================================\n")
cat("Analysis Completed Successfully\n")
cat("==========================================\n")

cat("\nGenerated Figures:\n")
cat("- permutation_test.png\n")
cat("- correlation_plot.png\n")
cat("- decision_tree.png\n")

cat("\nModule 06 Statistical Analyses Completed:\n")
cat("- Wilcoxon Rank Sum Test\n")
cat("- Kruskal-Wallis Test\n")
cat("- Permutation Testing\n")
cat("- Pearson Correlation\n")
cat("- Spearman Correlation\n")
cat("- Kendall Correlation\n")
cat("- Statistical Power Analysis\n")
cat("- Decision Tree Classification\n")
