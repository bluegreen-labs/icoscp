library(SPARQL)

source("R/zzz.R")
source("R/icos_stations.R")


test <- icos_stations(station = "FR-Tou")

print(head(test))
