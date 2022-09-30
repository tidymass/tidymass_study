no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
setwd("data_analysis/mass_dataset_class/")

## Introduction
##`mass_dataset` can be easily used with `ggplot2` package with
##`ggplot_mass_dataset` function. Now, `ggplot()` function also supports `mass_dataset` class.
## Data preparation
data("expression_data")
data("sample_info")
data("variable_info")

object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info
  )

## Sample wise
###We need to replace `ggplot` with `ggplot_mass_dataset`, and then other functions are same with `ggplot2` for graphics.
plot <-
  object %>%
  `+`(1) %>%
  log(10) %>%
  scale() %>%
  ggplot_mass_dataset(direction = "sample",
                      sample_index = 1)

class(plot)

##The default `y` is `value`, here is the intensity of all the features in the second sample.
plot
head(plot$data)

plot <-
  object %>%
  `+`(1) %>%
  log(10) %>%
  scale() %>%
  ggplot_mass_dataset(direction = "sample",
                      sample_index = 2) +
  geom_boxplot(aes(x = 1)) +
  geom_jitter(aes(x = 1, color = mz)) +
  theme_bw()

plot

# Variable wise
ggplot_mass_dataset(object, direction = "variable",
                    variable_index = 2) +
  geom_boxplot(aes(x = class, color = class)) +
  geom_jitter(aes(x = class, color = class)) +
  theme_bw()

object %>%
  `+`(1) %>%
  log(10) %>%
  scale() %>%
  ggplot_mass_dataset(direction = "variable",
                      variable_index = 2) +
  geom_boxplot(aes(x = class, color = class)) +
  geom_jitter(aes(x = class, color = class)) +
  theme_bw() +
  labs(x = "", y = "Z-score")

# `ggplot()` function
##You need use `activate_mass_dataset()` to tell which slot you want to use for `ggplot()`.
object %>%
  `+`(1) %>%
  log(10) %>%
  scale() %>%
  activate_mass_dataset(what = "variable_info") %>%
  ggplot(aes(rt, mz)) +
  geom_point() +
  theme_bw() +
  labs(x = "mz", y = "RT (second)")
