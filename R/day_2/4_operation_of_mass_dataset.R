no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
setwd("data_analysis/mass_dataset_class/")

data("expression_data")
data("sample_info")
data("variable_info")

object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info
  )

dim(object)
nrow(object)
ncol(object)

get_sample_number(object)
get_variable_number(object)
sum(is.na(object))
sum(object < 0, na.rm = TRUE)
sum(object > 0, na.rm = TRUE)

##sample id
colnames(object)

##variable id
rownames(object) %>%
  head()

##sample id
get_sample_id(object)

##variable id
get_variable_id(object) %>%
  head()

# Explore
###show mz rt plot
object %>%
  show_mz_rt_plot()

###should log
object %>%
  `+`(1) %>%
  log(10) %>%
  show_mz_rt_plot()

###use hex
object %>%
  show_mz_rt_plot(hex = TRUE)

##show missing values plot
show_missing_values(object)

show_missing_values(object[1:10, ], cell_color = "white")

###only show subject samples
object %>%
  activate_mass_dataset(what = "sample_info") %>%
  filter(class == "Subject") %>%
  show_missing_values()

###only show QC samples
object %>%
  activate_mass_dataset(what = "expression_data") %>%
  dplyr::select(contains("QC")) %>%
  show_missing_values()

###only show features with mz < 100
object %>%
  activate_mass_dataset(what = "variable_info") %>%
  dplyr::filter(mz < 100) %>%
  show_missing_values(
    cell_color = "white",
    show_row_names = TRUE,
    row_names_side = "left"
  )

##show missing values plot
show_sample_missing_values(object)

show_sample_missing_values(object, color_by = "class")

show_sample_missing_values(object, color_by = "class", order_by = "na")

show_sample_missing_values(object, color_by = "class", order_by = "na",
                           desc = TRUE)

##show missing values plot
show_variable_missing_values(object)

show_variable_missing_values(object, color_by = "mz")

show_variable_missing_values(object, color_by = "rt") +
  scale_color_gradient(low = "skyblue", high = "red") 

show_variable_missing_values(object, color_by = "mz", 
                             order_by = "na")

show_variable_missing_values(object, color_by = "mz", 
                             order_by = "na",
                             desc = TRUE, percentage = TRUE)
