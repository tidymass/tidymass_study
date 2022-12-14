no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())

dir.create(
  "data_analysis/metabolite_annotaion",
  showWarnings = FALSE,
  recursive = TRUE
)
setwd("data_analysis/metabolite_annotaion/")

# Data preparation
ms1_data <-
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
dir.create(path,
           recursive = TRUE)

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

extract_ms2_data(object)

# Identify metabolites according to MS1
data("snyder_database_rplc0.0.3", package = "metid")
data_base <- snyder_database_rplc0.0.3
data_base@spectra.data <- list()
data_base@spectra.info$RT <- NA

data_base

object1 <-
  annotate_metabolites_mass_dataset(object = object,
                                    database = data_base)

object1

extract_annotation_table(object1)


# Identify metabolites according to MS2
data("snyder_database_rplc0.0.3", package = "metid")

snyder_database_rplc0.0.3

object2 =
  annotate_metabolites_mass_dataset(object = object1,
                                    database = snyder_database_rplc0.0.3)

head(extract_annotation_table(object2))
head(extract_variable_info(object = object2))

# Identify metabolites according another database
data("orbitrap_database0.0.3", package = "metid")

object3 =
  annotate_metabolites_mass_dataset(object = object2,
                                    database = orbitrap_database0.0.3)

head(extract_variable_info(object = object3))

object3

summary_annotation_table(object = object3, level = c(1, 2, 3))

object3

export_mass_dataset(object = object3, path = "final_dataset")

variable_info <-
  extract_variable_info(object3)
head(variable_info)
write.csv(variable_info, file = "final_dataset/variable_info.csv", row.names = FALSE)
