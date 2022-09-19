##Download the demo data from BaiduYun and put it in raw_data folder, and then uncompress it.
##Link: https://pan.baidu.com/s/1kkPFSW2xrNNBUJb-77gsjw?pwd=1234
##Code: 1234
no_source()

library(tidymass)
masstools::setwd_project()
rm(list = ls())
setwd("raw_data/")

massprocesser::process_data(
  path = "cell_liang_2020/MS1/",
  polarity = "positive",
  ppm = 15,
  peakwidth = c(5, 30),
  snthresh = 5,
  noise = 500,
  threads = 6,
  output_tic = TRUE,
  output_bpc = TRUE,
  output_rt_correction_plot = TRUE,
  min_fraction = 0.5,
  fill_peaks = FALSE
)

##Extract EICs of some features
targeted_table <-
  readr::read_csv("cell_liang_2020/MS1/Result/Peak_table_for_cleaning.csv")

mean_int <- targeted_table %>% 
  dplyr::select(-c(variable_id:rt)) %>% 
  apply(1, function(x){
    mean(x, na.rm = TRUE)
  })

targeted_table<-
  targeted_table %>% 
  dplyr::select(variable_id:rt) %>% 
  dplyr::mutate(mean_int = mean_int) %>% 
  dplyr::arrange(dplyr::desc(mean_int)) %>% 
  head(10) %>% 
  dplyr::select(-mean_int)

targeted_table

load("cell_liang_2020/MS1/Result/intermediate_data/xdata3")

extract_eic(
  targeted_table = targeted_table,
  object = xdata3,
  polarity = "positive",
  mz_tolerance = 15,
  rt_tolerance = 30,
  threads = 3,
  add_point = FALSE,
  path = "cell_liang_2020/MS1/Result/",
  feature_type = "png", 
  group_for_figure = "Subject"
)

