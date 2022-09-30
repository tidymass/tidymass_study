###1. how to install packages
###1.1 From CRAN
install.packages("ggplot2")

###1.2 From BiocConductor
BiocManager::install("Rdisop")

###1.3 From Github
remotes::install_github("tidymass/masstools")

#### 2. load one package
library(masstools)

### 3. get help document
###3.1 package
help(package = "masstools")

###3.2 function
?ms2_plot

spectrum1 <- data.frame(
  mz = c(
    87.50874,
    94.85532,
    97.17808,
    97.25629,
    103.36186,
    106.96647,
    107.21461,
    111.00887,
    113.79269,
    118.70564
  ),
  intensity =
    c(
      8356.306,
      7654.128,
      9456.207,
      8837.188,
      8560.228,
      8746.359,
      8379.361,
      169741.797,
      7953.080,
      8378.066
    )
)
spectrum2 <- spectrum1

ms2_plot(spectrum1)

ms2_plot(spectrum1, interactive_plot = TRUE)

ms2_plot(spectrum1, spectrum2)

ms2_plot(spectrum1, spectrum2, interactive_plot = TRUE)


####4 object name
###show only contains letter, number, underline, and can't begin with number
a <- 1
this_matrix <-
  matrix(1:16, 4)

this_matrix

####5 system operation
getwd()
dir()
setwd(".")
setwd("..")
setwd("tidymass_study/")
masstools::get_os()
version

sessionInfo()

#####package installation directory
.libPaths()

###



