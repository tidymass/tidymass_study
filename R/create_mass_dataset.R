masstools::setwd_project()
library(tidyverse)
library(tidymass)
peak_table <- 
  readr::read_csv("raw_data/cell_liang_2020/MS1/Result/Peak_table_for_cleaning.csv")

colnames(peak_table)

variable_info <-
  peak_tabe[,1:3]

head(variable_info)

expression_data <-
  peak_tabe[,-c(1:3)]

rownames(expression_data) <- variable_info$variable_id
