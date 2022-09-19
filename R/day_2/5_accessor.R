no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
setwd("data_analysis/mass_dataset_class/")

## Data preparation
data("expression_data")
data("sample_info")
data("variable_info")

object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info
  )

object

## Base function
object[1:5,]
object[,1:5]
object[1:10,1:5]

colnames(object)
object[,"Blank_3"]

rownames(object) %>% head()
object["M136T55_2_POS",]

object["M136T55_2_POS","Blank_3"]

##If set `drop = TRUE`, then it will return a numeric vector, not a `mass_dataset`.

head(object[,"Blank_3", drop = TRUE])

unlist(object["M136T55_2_POS",,drop = TRUE] )

object["M136T55_2_POS","Blank_3",drop = TRUE]

##We can also get the values from one `mass_dataset` class use `$` like a `data.frame`.
head(object$Blank_3, 20)
