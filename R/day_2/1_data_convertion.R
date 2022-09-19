####This is only for mac users
##for windows users, just use the msconvert software, download it here:
##https://proteowizard.sourceforge.io/
no_source()

library(tidymass)
library(massconverter)
masstools::setwd_project()
rm(list = ls())
setwd("raw_data/")

## Open docker

## Pull pwiz docker

docker_pull_pwiz()

## Set the msconvert parameters
parameter <-
  massconverter::create_msconvert_parameter(
    output_format = "mzXML",
    binary_encoding_precision = "32",
    zlib = TRUE,
    write_index = TRUE,
    peak_picking_algorithm = "cwt",
    vendor_mslevels = c(1, NA),
    cwt_mslevels = c(1, NA),
    cwt_min_snr = 0.1,
    cwt_min_peak_spacing = 0.1,
    subset_polarity = "positive",
    subset_scan_number = c(NA, NA),
    subset_scan_time = c(60, 300),
    subset_mslevels = c(1, 2),
    zero_samples_mode = "removeExtra",
    zero_samples_mslevels = c(1, NA),
    zero_samples_add_missing_flanking_zero_count = 5
  )

parameter

convert_raw_data(
  input_path = "example/",
  output_path = "mzxml/",
  msconvert_parameter = parameter,
  docker_parameters = c(),
  process_all = FALSE
)
