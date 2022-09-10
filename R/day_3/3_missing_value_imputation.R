no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create("data_analysis/data_cleaning", showWarnings = FALSE)
setwd("data_analysis/data_cleaning/")

# **Introduction**
##We can use `masscleaner` for missing value (MV) imputation.
##First, we need to prepare samples for `masscleaner`.

# **Data preparation**
##Load the data in the previous step

load("peak_tables/POS/object")

get_mv_number(object)
head(massdataset::get_mv_number(object, by = "sample"))
head(massdataset::get_mv_number(object, by = "variable"))

head(massdataset::get_mv_number(object, by = "sample", show_by = "percentage"))
head(massdataset::get_mv_number(object, by = "variable"), show_by = "percentage")

# **Impute missing values**
## zero
object_zero = 
  impute_mv(object = object, method = "zero")
get_mv_number(object_zero)

## KNN
object = 
  impute_mv(object = object, method = "knn")
get_mv_number(object)

###More methods can be found `?impute_mv()`.

# **Note**
# If there are blank samples in dataset, we use different method to impute missing
# values.

# For Blank samples, just use the zero.
# For non-Blank samples, just use the knn or other method

# Save data for next analysis.

save(object, file = "peak_tables/POS/object")

