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

###add NA frequency (%) in sample_info
object2 =
  object %>% 
  mutate_sample_na_freq()

extract_sample_info(object2) %>% head()

###add NA number (%) in sample_info
object2 =
  object %>% 
  mutate_sample_na_number()

extract_sample_info(object2) %>% head()

###add NA number (%) in sample_info based on variables with mz > 200
variable_id = 
  object %>% 
  activate_mass_dataset(what = "variable_info") %>% 
  filter(mz > 200) %>% 
  pull(variable_id)

object2 =
  object %>% 
  mutate_sample_na_number(according_to_variables = variable_id)

extract_sample_info(object2) %>% head()

###add a new column named as sample_id2 in sample_info
object2 =
  object %>% 
  activate_mass_dataset(what = "sample_info") %>% 
  mutate(sample_id2 = sample_id)

extract_sample_info(object2) %>% head()

new_sample_info = 
  data.frame(sample_id = c("PS4P1", "PS4P2"), 
             BMI = c(20, 22))

object2 =
  object %>% 
  activate_mass_dataset(what = "sample_info") %>% 
  left_join(new_sample_info, by = "sample_id")

extract_sample_info(object2) %>% head()

###add mean intensity in variable_info
object2 =
  object %>% 
  mutate_mean_intensity()

extract_variable_info(object2) %>% head()

###add median intensity in variable_info
object2 =
  object %>% 
  mutate_median_intensity()

extract_variable_info(object2) %>% head()

###add mean intensity in variable_info based on QC sample
qc_id =
  object %>% 
  activate_mass_dataset(what = "sample_info") %>% 
  pull(sample_id)

object2 =
  object %>% 
  mutate_mean_intensity(according_to_samples = qc_id, na.rm = TRUE)

extract_variable_info(object2) %>% head()

###add RSD for each variable
object2 =
  object %>% 
  mutate_rsd()

extract_variable_info(object2) %>% head()

###add na
object2 =
  object %>% 
  mutate_sample_na_freq()

extract_variable_info(object2) %>% head()

###add na
object2 =
  object %>% 
  mutate_sample_na_number()

extract_variable_info(object2) %>% head()


###add a new column named as variable_id2 in variable_info
object2 =
  object %>% 
  activate_mass_dataset(what = "variable_info") %>% 
  mutate(variable_id2 = variable_id)

extract_sample_info(object2) %>% head()

new_variable_info = 
  data.frame(variable_id = c("M136T55_2_POS", "M79T35_POS"), 
             marker = c("yes", "no"))

object2 =
  object %>% 
  activate_mass_dataset(what = "variable_info") %>% 
  left_join(new_variable_info, by = "variable_id")

extract_variable_info(object2) %>% head()


##Add new samples to expression_data
colnames(object)

object2 = 
  object %>% 
  activate_mass_dataset(what = "expression_data") %>% 
  mutate(QC_3 = QC_2,
         QC_4 = 1:1000)

colnames(object2)

plot(object2$QC_2, object2$QC_3)

extract_sample_info(object2)
