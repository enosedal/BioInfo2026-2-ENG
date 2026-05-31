#!/usr/bin/env Rscript

# =========================================================
# TidyTuesday Visualization
# Module 05 - NGS Visualization
# Efrén Nosedal González
# =========================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(palmerpenguins, lib.loc = "~")
})

cat("=========================================\n")
cat("Generating TidyTuesday Plot\n")
cat("=========================================\n")

# =========================================================
# Create output directory
# =========================================================

dir.create("results/tidytuesday",
           recursive = TRUE,
           showWarnings = FALSE)

# =========================================================
# Load data
# =========================================================

data("penguins")

penguins_clean <- penguins %>%
  drop_na(species,
          body_mass_g,
          flipper_length_mm)

# =========================================================
# Visualization
# =========================================================

p <- ggplot(
  penguins_clean,
  aes(
    x = flipper_length_mm,
    y = body_mass_g,
    color = species
  )
) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Body Mass vs Flipper Length in Penguins",
    subtitle = "Palmer Penguins Dataset",
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  )

# =========================================================
# Save figure
# =========================================================

ggsave(
  filename = "results/tidytuesday/tidytuesday_penguins.png",
  plot = p,
  width = 8,
  height = 6
)

cat("Plot saved successfully.\n")
cat("=========================================\n")
