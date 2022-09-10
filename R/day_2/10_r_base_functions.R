no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
setwd("data_analysis/mass_dataset_class/")

###`mass_dataset` object support many R base functions.

data("expression_data")
data("sample_info")
data("variable_info")

object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info
  )

##For example, you can get the information of your object.
dim(object)
nrow(object)
ncol(object)

x = dimnames(object)
x[[1]] %>% head()
x[[2]] %>% head()

###This means that `object` has 1000 variables and 8 samples.
apply(object, 2, mean)

###You can also get the sample ids and variables.
colnames(object)
head(rownames(object))

###Use `[` to select variables and samples from object.
##only remain first 5 variables
object[1:5,]

##only remain first 5 samples
object[,1:5]

##only remain first 5 samples and 5 variables
object[1:5,1:5]

##If you know the variables or sample names you want to select, you can also use the samples ids or variables ids.
colnames(object)
object[,c("Blank_3", "Blank_4")]

###log
object2 = 
  log(object + 1, 10)
unlist(object[1,,drop = TRUE])
unlist(object2[1,,drop = TRUE])

###scale
object2 = 
  scale(object, center = TRUE, scale = TRUE)
unlist(object[1,,drop = TRUE])
unlist(object2[1,,drop = TRUE])