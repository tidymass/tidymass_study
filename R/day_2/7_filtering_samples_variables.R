no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
setwd("data_analysis/mass_dataset_class/")

## Data preparation

library(tidymass)

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

## Filtering samples

### `filter_samples()`

###only remain the samples with NA number < 4 in all variables
filter_samples(object, function(x) {
  sum(is.na(x)) / length(x) < 0.4
})

###give the index
filter_samples(object, function(x) {
  sum(is.na(x)) / length(x) < 0.4
}, prune = FALSE)

### `dplyr::filter()` function

###only remain the "QC" samples
object %>% 
  activate_mass_dataset(what = "sample_info") %>% 
  filter(class == "QC")

### `dplyr::select()` function

###only remain samples whose names contain "QC"
object2 = 
  object %>% 
  activate_mass_dataset(what = "expression_data") %>% 
  select(contains("QC"))
colnames(object2)

###only remain first 3 samples
object2 = 
  object %>% 
  activate_mass_dataset(what = "expression_data") %>% 
  select(1:3)
colnames(object2)

## Filtering variables

### `filter_variables()` function

####Filter variables which have more than 50% MVs in all samples.
filter_variables(object, function(x) {
  sum(is.na(x)) / length(x) < 0.5
}, prune = FALSE) %>%
  head()

filter_variables(object, function(x) {
  sum(is.na(x)) / length(x) < 0.5
},
prune = TRUE)

### `dplyr::filter()` function

####Filter variables which mz > 500
object %>% 
  activate_mass_dataset(what = "variable_info") %>% 
  filter(mz > 500)

####Filter variables which mz > 500 and rt > 100
object %>% 
  activate_mass_dataset(what = "variable_info") %>% 
  filter(mz > 500 & rt > 100)

