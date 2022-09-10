no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())

load("data_analysis/in_house_database_construction/test.database")

dir.create("data_analysis/output_database",
           showWarnings = FALSE,
           recursive = TRUE)
setwd("data_analysis/in_house_database_construction/")

# **MassBank**
## `msp` format
write_msp_massbank(database = test.database, path = ".")


## `mgf` format
write_mgf_massbank(databasae = test.database, path = ".")

# **MoNA**
## `msp` format
write_msp_mona(databasae = databasae, path = ".")

## `mgf` format
write_mgf_mona(databasae = databasae, path = ".")

# **GNPS**
## `msp` format
write_msp_gnps(databasae = databasae, path = ".")

## `mgf` format
write_mgf_gnps(databasae = databasae, path = ".")
