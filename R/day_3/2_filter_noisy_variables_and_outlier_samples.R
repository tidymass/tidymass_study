no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create("data_analysis/data_cleaning", showWarnings = FALSE)
setwd("data_analysis/data_cleaning/")

# Introduction
##We can use `masscleaner` to remove noisy features and outlier samples.
##First, we need to prepare samples for `masscleaner`.
##Download the demo data: [peak tables](https://drive.google.com/file/d/1mXljBn8lbEMlN4tMHaSFLNsJRmZwKPhU/view?usp=sharing) and uncompress.

##Download the demo data: [sample information](https://drive.google.com/file/d/1yyJeOMUhuMSTmPWfzKuFTCRfZ3zdhO6q/view?usp=sharing) and uncompress.

# Data preparation

##Here we only use the positive mode as an example.

peak_table_pos <-
  readr::read_csv("peak_tables/POS/Peak_table_for_cleaning.csv") %>%
  as.data.frame()
sample_info_pos = readr::read_csv("sample_info/sample_info_pos.csv") %>%
  as.data.frame()

expression_data_pos <-
  peak_table_pos %>%
  dplyr::select(-c(variable_id, mz, rt))

variable_info_pos <-
  peak_table_pos %>%
  dplyr::select(c(variable_id, mz, rt))

rownames(expression_data_pos) = variable_info_pos$variable_id
dim(expression_data_pos)
dim(sample_info_pos)
colnames(expression_data_pos) == sample_info_pos$sample_id

expression_data_pos =
  expression_data_pos[, sample_info_pos$sample_id]

sum(colnames(expression_data_pos) == sample_info_pos$sample_id)

object <-
  create_mass_dataset(
    expression_data = expression_data_pos,
    sample_info = sample_info_pos,
    variable_info = variable_info_pos
  )

object

###Summary information.
get_mv_number(object)
massdataset::get_mv_number(object, by = "sample") %>%
  head()

head(massdataset::get_mv_number(object, by = "variable"))

massdataset::get_mv_number(object, by = "sample", show_by = "percentage") %>%
  head()

head(massdataset::get_mv_number(object, by = "variable"), show_by = "percentage")

# Filter noisy features
##Remove variables who have mv in more than 20 % QC samples and in at lest 50% samples in control group or case group.
object %>%
  activate_mass_dataset(what = "sample_info") %>%
  dplyr::count(group)

show_variable_missing_values(object = object,
                             percentage = TRUE) +
  scale_size_continuous(range = c(0.01, 2))

qc_id =
  object %>%
  activate_mass_dataset(what = "sample_info") %>%
  filter(class == "QC") %>%
  pull(sample_id)

control_id =
  object %>%
  activate_mass_dataset(what = "sample_info") %>%
  filter(group == "Control") %>%
  pull(sample_id)

case_id =
  object %>%
  activate_mass_dataset(what = "sample_info") %>%
  filter(group == "Case") %>%
  pull(sample_id)

object =
  object %>%
  mutate_variable_na_freq(according_to_samples = qc_id) %>%
  mutate_variable_na_freq(according_to_samples = control_id) %>%
  mutate_variable_na_freq(according_to_samples = case_id)

head(extract_variable_info(object))

object <-
  object %>%
  activate_mass_dataset(what = "variable_info") %>%
  filter(na_freq < 0.2 & (na_freq.1 < 0.5 | na_freq.2 < 0.5))
object

show_variable_missing_values(object = object[, qc_id],
                             percentage = TRUE)

show_variable_missing_values(object = object[, control_id],
                             percentage = TRUE)

show_variable_missing_values(object = object[, case_id],
                             percentage = TRUE)

object %>%
  activate_mass_dataset(what = "variable_info") %>%
  dplyr::filter(na_freq.1 > 0.5) %>%
  extract_variable_info() %>%
  ggplot(aes(na_freq.1, na_freq.2)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(0, 1))


object %>%
  activate_mass_dataset(what = "variable_info") %>%
  dplyr::filter(na_freq.2 > 0.5) %>%
  extract_variable_info() %>%
  ggplot(aes(na_freq.1, na_freq.2)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(0, 1))

# Filter outlier samples
##We can use the `detect_outlier()` to find the outlier samples.
##More information about how to detect outlier samples can be found 
##[here](https: // privefl.github.io / blog / detecting - outlier - samples - in-pca / ).

massdataset::show_sample_missing_values(
  object = object,
  color_by = "group",
  order_by = "injection.order",
  percentage = TRUE
) +
  ggsci::scale_color_aaas()

###Detect outlier samples.
outlier_samples =
  object %>%
  `+`(1) %>%
  log(2) %>%
  scale() %>%
  detect_outlier()

outlier_samples

outlier_table <-
  extract_outlier_table(outlier_samples)
outlier_table %>%
  head()

outlier_table %>%
  apply(1, function(x) {
    sum(x)
  }) %>%
  `>`(0) %>%
  which()

##No outlier samples.

##Save data for next analysis.

save(object, file = "peak_tables/POS/object")
