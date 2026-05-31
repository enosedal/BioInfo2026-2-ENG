############################################################
# Module 06 - Statistics for Biological Data
# Assignment 1 - Fundamentals and Descriptive Statistics
#
# Author: Efren Nosedal Gonzalez
############################################################

# Load required packages
library(dplyr)
library(ggplot2)

############################################################
# PART 1 - BRDU DATA
############################################################

# Read data
# Replace with your actual file name if needed

celulas.brdu <- read.csv(
  "../data/celulas_brdu.csv",
  stringsAsFactors = TRUE
)

############################################################
# DESCRIPTIVE STATISTICS
############################################################

DT.celulas <- celulas.brdu %>%
  summarise(
    media = mean(celulas),
    sd = sd(celulas),
    min = min(celulas),
    max = max(celulas)
  )

print(DT.celulas)

GT.celulas <- celulas.brdu %>%
  group_by(grupo) %>%
  summarise(
    n = n(),
    media = mean(celulas),
    sd = sd(celulas),
    min = min(celulas),
    max = max(celulas)
  )

print(GT.celulas)

write.csv(
  DT.celulas,
  "../results/descriptive_statistics.csv",
  row.names = FALSE
)

write.csv(
  GT.celulas,
  "../results/group_statistics.csv",
  row.names = FALSE
)

############################################################
# HISTOGRAM - BRDU CELLS
############################################################

png(
  "../figures/hist_brdu.png",
  width = 1200,
  height = 900,
  res = 150
)

hist(
  celulas.brdu$celulas,
  main = "Células BrdU",
  xlab = "Número de células"
)

dev.off()

############################################################
# DENSITY BY GROUP
############################################################

png(
  "../figures/density_groups.png",
  width = 1200,
  height = 900,
  res = 150
)

ggplot(
  celulas.brdu,
  aes(
    x = celulas,
    fill = grupo
  )
) +
  geom_density(alpha = 0.4)

dev.off()

############################################################
# BARPLOT BY GROUP
############################################################

barplot_groups <- ggplot(
  celulas.brdu,
  aes(
    x = grupo,
    y = celulas,
    fill = grupo
  )
) +
  stat_summary(
    fun = mean,
    geom = "bar",
    width = 0.6,
    colour = "black"
  ) +
  theme_minimal() +
  labs(
    title = "Células BrdU positivas",
    x = "Grupo",
    y = "Células"
  )

png(
  "../figures/barplot_groups.png",
  width = 1200,
  height = 900,
  res = 150
)

print(barplot_groups)

dev.off()

############################################################
# PART 2 - RNORM EXERCISE (N = 5000)
############################################################

set.seed(10)

estaturas <- rnorm(
  n = 5000,
  mean = 170,
  sd = 8
)

png(
  "../figures/rnorm_5000.png",
  width = 1200,
  height = 900,
  res = 150
)

hist(
  estaturas,
  main = "Estaturas simuladas (n = 5000)",
  xlab = "cm"
)

dev.off()

############################################################
# PART 3 - SAMPLE EXERCISE (N = 30)
############################################################

datos <- rexp(10000)

medias2 <- numeric(10000)

for(i in 1:10000){

  muestra <- sample(
    datos,
    30
  )

  medias2[i] <- mean(muestra)
}

png(
  "../figures/sample_n30.png",
  width = 1200,
  height = 900,
  res = 150
)

hist(
  medias2,
  main = "Distribución de medias muestrales (n = 30)",
  xlab = "Media"
)

dev.off()

############################################################
# END
############################################################

cat("\nAssignment 1 completed successfully.\n")
