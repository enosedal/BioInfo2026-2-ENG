#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(httr)
  library(jsonlite)
  library(dplyr)
  library(readr)
})

genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

query_pdb <- function(gene) {

  query_body <- list(
    query = list(
      type = "terminal",
      service = "text",
      parameters = list(
        attribute = "rcsb_entity_source_organism.rcsb_gene_name.value",
        operator = "exact_match",
        value = gene
      )
    ),
    request_options = list(return_all_hits = FALSE),
    return_type = "entry"
  )

  response <- POST(
    "https://search.rcsb.org/rcsbsearch/v2/query",
    body = query_body,
    encode = "json"
  )

  if (http_error(response)) {
    return(data.frame(
      Gene = gene,
      PDB_ID = NA,
      Method = NA,
      Resolution = NA,
      AlphaFold_Model = paste0("https://alphafold.ebi.ac.uk/search/text/", gene)
    ))
  }

  parsed <- tryCatch(
    fromJSON(content(response, "text", encoding = "UTF-8")),
    error = function(e) return(NULL)
  )

  if (is.null(parsed) ||
      is.null(parsed$result_set) ||
      length(parsed$result_set$identifier) == 0) {

    return(data.frame(
      Gene = gene,
      PDB_ID = NA,
      Method = NA,
      Resolution = NA,
      AlphaFold_Model = paste0("https://alphafold.ebi.ac.uk/search/text/", gene)
    ))
  }

  pdb_id <- parsed$result_set$identifier[1]

  entry_url <- paste0(
    "https://data.rcsb.org/rest/v1/core/entry/",
    pdb_id
  )

  entry <- tryCatch(
    fromJSON(content(GET(entry_url), "text", encoding = "UTF-8")),
    error = function(e) return(NULL)
  )

  method <- NA
  resolution <- NA

  if (!is.null(entry)) {

    if (!is.null(entry$exptl) && length(entry$exptl) > 0 &&
        !is.null(entry$exptl[[1]]$method)) {
      method <- entry$exptl[[1]]$method
    }

    if (!is.null(entry$rcsb_entry_info$resolution_combined)) {
      resolution <- entry$rcsb_entry_info$resolution_combined[1]
    }
  }

  data.frame(
    Gene = gene,
    PDB_ID = pdb_id,
    Method = method,
    Resolution = resolution,
    AlphaFold_Model = paste0(
      "https://alphafold.ebi.ac.uk/search/text/",
      gene
    )
  )
}

results <- bind_rows(lapply(genes, query_pdb))

write_csv(results, "../results/table_C_structures.csv")

print(results)
