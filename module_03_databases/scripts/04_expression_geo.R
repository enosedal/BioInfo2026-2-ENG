#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(GEOquery)
})

gse <- getGEO("GSE33630", GSEMatrix = TRUE)
expr <- exprs(gse[[1]])

write.csv(expr[1:20, 1:5], "../results/table_D_expression.csv")
print(dim(expr))
