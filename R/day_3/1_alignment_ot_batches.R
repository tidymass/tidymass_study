no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create("data_analysis/data_cleaning", showWarnings = FALSE)
setwd("data_analysis/data_cleaning/")

# **Data preparation**
##See the [massdataset](https://tidymass.github.io/massdataset/) package, 
##and create you metabolomics dataset into 2 mass_dataset objects.

##Here we use the demo data from `demodata` package, so please install it first.

if(!require(devtools)){
  install.packages("devtools")
}
devtools::install_github("tidymass/demodata")

library(demodata)

# **Run `align_batch()` function**

data(object1, package = "demodata")
data(object2, package = "demodata")

object1
object2

x = object1
y = object2

match_result =
  align_batch(x = object1, y = object2, return_index = TRUE)

head(match_result)

new_object =
  align_batch(x = object1, y = object2, return_index = FALSE)

new_object
