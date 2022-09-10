no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
setwd("data_analysis/mass_dataset_class/")

## rbind or cbind `mass_dataset`

##If you have two `mass_dataset`, you can use `cbind` or `rbind` to merge them as one `mass_dataset`.

### `cbind()`

##`cbind()` means that two `mass_dataset` have same variables and totally different samples.

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

object1 = 
  object[,1:4]

object2 = 
  object[,5:8]

colnames(object1)
colnames(object2)

cbind(object1, object2)


### `rbind()`

##`rbind()` means that two `mass_dataset` have same samples and totally different variables

object1 = 
  object[1:10,]

object2 = 
  object[11:15,]

rownames(object1)
rownames(object2)

rbind(object1, object2)

## Split `mass_dataset`
##In `massdataset` package, the `split_mass_dataset` is used to split `mass_dataset` to different class objects.

### Data preparation
data("expression_data")
data("sample_info")
data("variable_info")

object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info
  )

### Split based on sample information
object <-
  activate_mass_dataset(object, what = "sample_info")

new_object <-
  split_mass_dataset(object = object, by = "group")

new_object %>% lapply(dim)
new_object %>% lapply(colnames)
extract_process_info(new_object[[1]])$split_mass_dataset

### Split based on variable information
object <-
  activate_mass_dataset(object, what = "variable_info")

new_object <-
  split_mass_dataset(object = object, by = "rt", fun = function(rt) rt > 600)

new_object %>% lapply(dim)

plot(extract_variable_info(new_object[[1]])$rt)
plot(extract_variable_info(new_object[[2]])$rt)

extract_process_info(new_object[[1]])$split_mass_dataset

