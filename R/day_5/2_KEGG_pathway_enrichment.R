no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create("data_analysis/pathway_enrichment",
           showWarnings = FALSE)

setwd("data_analysis/pathway_enrichment/")


# Load KEGG pathway human database
data("kegg_hsa_pathway", package = "metpath")
kegg_hsa_pathway

get_pathway_class(kegg_hsa_pathway)


# Pathway enrichment
# We use the demo compound list from `metpath`.

data("query_id_kegg", package = "metpath")
query_id_kegg

# Remove the disease pathways:
  
#get the class of pathways
pathway_class = 
  metpath::pathway_class(kegg_hsa_pathway)

head(pathway_class)

remain_idx =
  pathway_class %>%
  unlist() %>%
  stringr::str_detect("Disease") %>%
  `!`() %>%
  which()

remain_idx

pathway_database =
  kegg_hsa_pathway[remain_idx]

pathway_database

result = 
  enrich_kegg(query_id = query_id_kegg, 
              query_type = "compound", 
              id_type = "KEGG",
              pathway_database = pathway_database, 
              p_cutoff = 0.05, 
              p_adjust_method = "BH", 
              threads = 3)

# Check the result:
result

# Plot to show pathway enrichment
enrich_bar_plot(object = result)

enrich_scatter_plot(object = result)

enrich_network(object = result)
