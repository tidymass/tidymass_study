no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())

dir.create("data_analysis/metabolite_annotaion",
           showWarnings = FALSE)
setwd("data_analysis/metabolite_annotaion/")

# Data preparation
ms1_data =
  readr::read_csv(file.path(
    system.file("ms1_peak", package = "metid"),
    "ms1.peak.table.csv"
  ))

ms1_data = data.frame(ms1_data, sample1 = 1, sample2 = 2)

expression_data = ms1_data %>%
  dplyr::select(-c(name:rt))

variable_info =
  ms1_data %>%
  dplyr::select(name:rt) %>%
  dplyr::rename(variable_id = name)

sample_info =
  data.frame(
    sample_id = colnames(expression_data),
    injection.order = c(1, 2),
    class = c("Subject", "Subject"),
    group = c("Subject", "Subject")
  )
rownames(expression_data) = variable_info$variable_id

object = create_mass_dataset(
  expression_data = expression_data,
  sample_info = sample_info,
  variable_info = variable_info
)

object

# Add MS2 to `mass_dataset` object
path = "ms2_data"
dir.create(path)

ms2_data <- system.file("ms2_data", package = "metid")
file.copy(
  from = file.path(ms2_data, "QC1_MSMS_NCE25.mgf"),
  to = path,
  overwrite = TRUE,
  recursive = TRUE
)

object =
  massdataset::mutate_ms2(
    object = object,
    column = "rp",
    polarity = "positive",
    ms1.ms2.match.mz.tol = 10,
    ms1.ms2.match.rt.tol = 30
  )

object

object@ms2_data



# Annotate single peaks
data("snyder_database_rplc0.0.3", package = "metid")

annotate_single_peak_mass_dataset(
  object = object,
  variable_index = 3,
  based_on_rt = FALSE,
  based_on_ms2 = FALSE,
  database = snyder_database_rplc0.0.3,
  add_to_annotation_table = FALSE
)

annotate_single_peak_mass_dataset(
  object = object,
  variable_index = 3,
  based_on_rt = TRUE,
  based_on_ms2 = FALSE,
  database = snyder_database_rplc0.0.3,
  add_to_annotation_table = FALSE
)

annotate_single_peak_mass_dataset(
  object = object,
  variable_index = 3,
  based_on_rt = TRUE,
  based_on_ms2 = TRUE,
  database = snyder_database_rplc0.0.3,
  add_to_annotation_table = FALSE
)

# Add to object
extract_annotation_table(object)

object1 =
  annotate_single_peak_mass_dataset(
    object = object,
    variable_index = 3,
    based_on_rt = FALSE,
    based_on_ms2 = FALSE,
    database = snyder_database_rplc0.0.3,
    add_to_annotation_table = TRUE
  )

extract_annotation_table(object1)

object2 <-
  annotate_single_peak_mass_dataset(
    object = object1,
    variable_index = 3,
    based_on_rt = TRUE,
    based_on_ms2 = FALSE,
    database = snyder_database_rplc0.0.3,
    add_to_annotation_table = TRUE
  )

extract_annotation_table(object2)

object3 =
  annotate_single_peak_mass_dataset(
    object = object2,
    variable_index = 3,
    based_on_rt = TRUE,
    based_on_ms2 = FALSE,
    database = snyder_database_rplc0.0.3,
    add_to_annotation_table = TRUE
  )

extract_annotation_table(object3)
