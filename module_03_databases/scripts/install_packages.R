#!/usr/bin/env Rscript

personal_lib <- Sys.getenv("R_LIBS_USER")
if (!dir.exists(personal_lib)) dir.create(personal_lib, recursive = TRUE)
.libPaths(c(personal_lib, .libPaths()))

cran_packages <- c(
  "dplyr",
  "readr",
  "httr",
  "jsonlite",
  "gwasrapidd",
  "GEOquery",
  "biomaRt"
)

installed <- rownames(installed.packages())

for (pkg in cran_packages) {
  if (!pkg %in% installed) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

cat("\nAll packages installed/verified.\n")
