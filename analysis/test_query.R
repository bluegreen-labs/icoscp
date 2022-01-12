library(SPARQL)

source("R/zzz.R")
source("R/icos_stations.R")
source("R/icos_products.R")
source("R/icos_collections.R")
source("R/icos_dobj_info.R")
source("R/icos_citation.R")
source("R/icos_download.R")

# test <- icos_stations()
#
# bla <- icos_products(
#   'http://meta.icos-cp.eu/resources/stations/ES_SE-Nor',
#   level = "all",
#   domain = "all")
#
#cols <- icos_collections()

dobj <- "https://meta.icos-cp.eu/objects/lNJPHqvsMuTAh-3DOvJejgYc"

icos_download(dobj = dobj)

# icos_dobj_info(dobj)
# print(icos_citation(dobj))

#https://data.icos-cp.eu/licence_accept?ids=%5B%22lNJPHqvsMuTAh-3DOvJejgYc%22%5D
