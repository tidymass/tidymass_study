no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create(
  "data_analysis/mass_dataset_class/",
  showWarnings = FALSE,
  recursive = TRUE
)
setwd("data_analysis/mass_dataset_class/")

data("expression_data", package = "massdataset")
data("sample_info", package = "massdataset")
data("variable_info", package = "massdataset")

head(expression_data)
head(sample_info)
head(variable_info)

object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info
  )

object

export_mass_dataset(object = object,
                    file_type = "xlsx",
                    path = "export_data")

# mzMine feature table to mass_dataset class

data("mzmine_table")
head(mzmine_table)

object <-
  convet_mzmine2mass_dataset(x = mzmine_table)
object

data("msdial_table")
head(msdial_table)

object <-
  convert_msdial2mass_dataset(x = msdial_table)
object

## Add MS2 spectra data into mass_dataset class object
load("../../raw_data/cell_liang_2020/MS1/Result/object")
object

object =
  mutate_ms2(
    object = object,
    column = "rp",
    polarity = "positive",
    ms1.ms2.match.mz.tol = 10,
    ms1.ms2.match.rt.tol = 15,
    path = "../../raw_data/cell_liang_2020/MS2"
  )

object

##Extract data from mass_dataset
##sample_info
extract_sample_info(object) %>%
  head()

##variable_info
extract_variable_info(object) %>%
  head()

##expression_data
extract_expression_data(object) %>%
  head()

##sample_info_note
extract_sample_info_note(object)

##variable_info_note
extract_variable_info_note(object)

##process_info
extract_process_info(object)

##Processing information in mass_dataset class
object =
  object %>%
  activate_mass_dataset(what = "expression_data") %>%
  filter(!is.na(184))

object =
  object %>%
  activate_mass_dataset(what = "expression_data") %>%
  filter(!is.na(214))

object =
  object %>%
  mutate_mean_intensity()

object =
  object %>%
  mutate_median_intensity() %>%
  mutate_rsd()

process_info = extract_process_info(object)
process_info

process_info$mutate_median_intensity

process_info$mutate_median_intensity@parameter

report_parameters(object = object, path = "parameters")
