no_source()

library(massdatabase)
masstools::setwd_project()
rm(list = ls())

dir.create("data_analysis/massdatabase",
           showWarnings = FALSE,
           recursive = TRUE)

setwd("data_analysis/massdatabase/")

# "Read functions" is series functions that could be used to read
# downloaded online databases. And "convert functions" is series functions that could be used to convert them to other formats.
# BIGG model database

# [BIGG model](http://bigg.ucsd.edu/)is a knowledge base of genome-scale metabolic network reconstructions.

# Read and convert the BIGG model data
library(metid)
library(massdatabase)
library(metpath)

# GNPS database
# Read and convert one GNPS compound database
download_gnps_spectral_library(gnps_library = "HMDB",
                               path = "GNPS_HMDB_compound")
data <-
  read_msp_data_gnps(file = "GNPS_HMDB_compound/HMDB.msp")

gnps_database <-
  convert_gnps2metid(data = data, path = "GNPS_HMDB_compound/")

# KEGG database
# download_kegg_pathway(path = "KEGG_pathway/", organism = "hsa")
data <-
  read_kegg_pathway(path = "KEGG_pathway/")

kegg_pathway_database <-
  convert_kegg2metpath(data = data, path = "KEGG_pathway/")

# SMPDB
# Read and convert SMPDB pathway database.
download_smpdb_pathway(path = "SMPDB_pathway")
data <-
  read_smpdb_pathway(path = "SMPDB_pathway",
                     only_primarity_pathway = TRUE)
smpdb_pathway_database <-
  convert_smpdb2metpath(data = data, path = "SMPDB_pathway")

smpdb_pathway_database
