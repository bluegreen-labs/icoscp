library(SPARQL)

source("R/zzz.R")
source("R/icos_stations.R")
source("R/icos_station_data.R")

test <- icos_stations("FR-Tou")

print(head(test))
#
# library(tidyverse)
#
# bla <- test %>%
#   filter(
#    id == "FR-Tou"
#   ) %>%
#   select(uri)
#
# icos_station_data('http://meta.icos-cp.eu/resources/stations/ES_FR-Tou')
