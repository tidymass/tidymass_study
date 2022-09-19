no_source()

## Install tidyverse

if (!require(tidyverse)) {
  install.packages("tidyverse")
}

library(tidyverse)

## Install tidyMass

if (!require(remotes)) {
  install.packages("remotes")
}

if (!require(tidymass)) {
  remotes::install_gitlab("tidymass/tidymass", dependencies = TRUE)
}

library(tidymass)

## Install other packages
if (!require(massconverter)) {
  remotes::install_gitlab("tidymass/massconverter", dependencies = TRUE)
}

if (!require(massdatabase)) {
  remotes::install_gitlab("tidymass/massdatabase", dependencies = TRUE)
}

if (!require(demodata)) {
  remotes::install_github("tidymass/demodata", dependencies = TRUE)
}