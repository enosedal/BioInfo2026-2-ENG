#!/usr/bin/env Rscript

# =========================================================
# install_packages.R
# Bioinformatics course package installer
# =========================================================

# Setup personal local library to bypass system write restrictions
personal_lib <- Sys.getenv("R_LIBS_USER")
if(!dir.exists(personal_lib)) dir.create(personal_lib, recursive = TRUE)
.libPaths(c(personal_lib, .libPaths()))

cran_packages <- c(
  "dplyr",
  "readr",
  "httr",
  "jsonlite",
  "gwasrapidd"
)

bioc_packages <- c(
  "BiocManager",
  "biomaRt",
  "GEOquery",
  "clusterProfiler",
  "org.Hs.eg.db",
  "STRINGdb"
)

installed <- rownames(installed.packages())

# ---------------------------------------------------------
# Install CRAN packages
# ---------------------------------------------------------

for(pkg in cran_packages){

  if(!pkg %in% installed){

    install.packages(
      pkg,
      repos = "https://cloud.r-project.org"
    )

  }

}

# ---------------------------------------------------------
# Install BiocManager first
# ---------------------------------------------------------

if(!"BiocManager" %in% installed){

  install.packages(
    "BiocManager",
    repos = "https://cloud.r-project.org"
  )

}

# ---------------------------------------------------------
# Install Bioconductor packages
# ---------------------------------------------------------

for(pkg in bioc_packages){

  if(!pkg %in% rownames(installed.packages())){

    BiocManager::install(
      pkg,
      ask = FALSE,
      update = FALSE
    )

  }

}

cat("\nAll requested packages checked/installed.\n")
