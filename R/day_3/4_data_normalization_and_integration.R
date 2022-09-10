no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create("data_analysis/data_cleaning", showWarnings = FALSE)
setwd("data_analysis/data_cleaning/")

# We can use `masscleaner` for data normalization and data integration.
# First, we need to prepare samples for `masscleaner`.

# **Data preparation**
# Load data from the previous step
load("peak_tables/POS/object")
object

# **Data quality assessment**

# We can use the [`massqc` package](https://tidymass.github.io/massqc/) to assess the data quality.
object <-
  object %>%
  activate_mass_dataset(what = "sample_info") %>%
  dplyr::mutate(batch = as.character(batch))

object %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_pca(color_by = "batch", line = FALSE)

# We can see the clear batch effect.
object %>%
  activate_mass_dataset(what = "sample_info") %>%
  dplyr::filter(class == "QC") %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_sample_boxplot(color_by = "group",
                                order_by = "injection.order") +
  theme(axis.text.x = element_text(
    angle = 45,
    hjust = 1,
    vjust = 1
  ))

object %>%
  activate_mass_dataset(what = "sample_info") %>%
  dplyr::filter(class == "QC") %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_rsd_plot()

object %>%
  activate_mass_dataset(what = "sample_info") %>%
  dplyr::filter(class == "QC") %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_sample_correlation(method = "square", tl.cex = 5) +
  theme(axis.text = element_text(size = 5))

# **Data normalization**

## Total/median/mean
object1 <-
  normalize_data(object, method = "total")

##PCA
object1 %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_pca(color_by = "batch", line = FALSE)

object2 <-
  normalize_data(object, method = "median")

##PCA
object2 %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_pca(color_by = "batch", line = FALSE)

object3 <-
  normalize_data(object, method = "mean")

##PCA
object3 %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_pca(color_by = "batch", line = FALSE)

## Loess/SVR
object4 <-
  masscleaner::normalize_data(object, method = "loess")

##PCA
object4 %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_pca(color_by = "batch", line = FALSE)

object5 <-
  masscleaner::normalize_data(object, method = "svr")

##PCA
object5 %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_pca(color_by = "batch", line = FALSE)

##We select the median method.
object_normalization <- object2

# **Data integration**
object_integration <-
  integrate_data(object_normalization, method = "qc_median")

##PCA
object_integration %>%
  `+`(1) %>%
  log(2) %>%
  massqc::massqc_pca(color_by = "batch", line = FALSE)

##Then we can draw the compare plot for RSD:
qc_id =
  object %>%
  activate_mass_dataset(what = "sample_info") %>%
  filter(class == "QC") %>%
  pull(sample_id)

rsd_before =
  object %>%
  mutate_rsd(according_to_samples = qc_id) %>%
  activate_mass_dataset(what = "variable_info") %>%
  pull(rsd)

rsd_after =
  object_integration %>%
  mutate_rsd(according_to_samples = qc_id) %>%
  activate_mass_dataset(what = "variable_info") %>%
  pull(rsd)

data.frame(rsd_before, rsd_after) %>%
  dplyr::mutate(
    class = dplyr::case_when(
      rsd_after < rsd_before ~ "Decrease",
      rsd_after > rsd_before ~ "Increase",
      rsd_after == rsd_before ~ "Equal"
    )
  ) %>%
  ggplot(aes(rsd_before, rsd_after, colour = class)) +
  ggsci::scale_color_jama() +
  geom_abline(slope = 1, intercept = 0) +
  geom_point() +
  labs(x = "RSD after normalization", y = "RSD before normalization") +
  theme_bw()

intensity_plot(
  object = object,
  variable_index = 1,
  color_by = "group",
  order_by = "injection.order",
  interactive = FALSE
)

intensity_plot(
  object = object_integration,
  variable_index = 1,
  color_by = "group",
  order_by = "injection.order",
  interactive = FALSE
)

###Save for next analysis.
save(object_integration, file = "peak_tables/POS/object_integration")
