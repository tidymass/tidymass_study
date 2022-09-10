no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
dir.create("data_analysis/in_house_database_construction",
           showWarnings = FALSE)

setwd("data_analysis/in_house_database_construction/")

test.database <-
  metid::construct_database(
    path = ".",
    version = "0.0.1",
    metabolite.info.name = "metabolite.info_RPLC.csv",
    source = "Michael Snyder lab",
    link = "http://snyderlab.stanford.edu/",
    creater = "Xiaotao Shen",
    email = "shenxt1990@163.com",
    rt = TRUE,
    mz.tol = 15,
    rt.tol = 30,
    threads = 3
  )

test.database

save(test.database, file = "test.database")
