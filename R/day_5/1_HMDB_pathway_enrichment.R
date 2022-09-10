no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create("data_analysis/pathway_enrichment",
           showWarnings = FALSE,
           recursive = TRUE)

setwd("data_analysis/pathway_enrichment/")

## Load HMDB pathway database
data("hmdb_pathway", package = "metpath")
hmdb_pathway

get_pathway_class(hmdb_pathway)

## Pathway enrichment
# We use the demo compound list from `metpath`.

data("query_id_hmdb", package = "metpath")
query_id_hmdb

# Only remain the `Metabolic;primary_pathway`.


#get the class of pathways
pathway_class =
  metpath::pathway_class(hmdb_pathway)

remain_idx = which(unlist(pathway_class) == "Metabolic;primary_pathway")

remain_idx

hmdb_pathway =
  hmdb_pathway[remain_idx]

hmdb_pathway

result =
  enrich_hmdb(
    query_id = query_id_hmdb,
    query_type = "compound",
    id_type = "HMDB",
    pathway_database = hmdb_pathway,
    only_primary_pathway = TRUE,
    p_cutoff = 0.05,
    p_adjust_method = "BH",
    threads = 3
  )

# Check the result:
result

## Plot to show pathway enrichment
enrich_bar_plot(
  object = result,
  x_axis = "p_value_adjust",
  cutoff = 0.05,
  top = 10
)

enrich_scatter_plot(object = result)

enrich_network(object = result)
