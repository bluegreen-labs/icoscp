context("test icoscp queries")

# RCurl (windows) settings
options(
  RCurlOptions =
    list(verbose = FALSE,
        capath = system.file("CurlSSL", "cacert.pem", package = "RCurl"),
        ssl.verifypeer = FALSE)
  )

# libraries (fail to dynamically load -- issue with SPARQL?)
library(RCurl)

test_that("station checks",{
  skip_on_cran()

  # download the data
  expect_type(
    icos_stations(),
    "list"
    )

  # download the data
  expect_type(
    icos_stations(station = "FR-Tou"),
    "list"
  )

  # corrupted station
  expect_null(
    icos_stations(station = "FR-To")
    )
})

test_that("collection checks",{
  skip_on_cran()

  # download the data
  expect_type(
    icos_collections(),
    "list"
  )

  # download the data
  expect_type(
    icos_collections(id = "10.18160/B3Q6-JKA0"),
    "list"
  )

  # corrupted station
  expect_null(
    icos_collections(id = "xxx")
  )

})

test_that("product checks",{
  skip_on_cran()

  # download the data
  expect_type(
    icos_products(
      'http://meta.icos-cp.eu/resources/stations/ES_SE-Nor',
      level = "all"
      ),
    "list"
  )

  # download the data
  expect_type(
    icos_products(
      'http://meta.icos-cp.eu/resources/stations/ES_SE-Nor',
      level = 2
    ),
    "list"
  )

  # no URI
  expect_null(
    icos_products(),
    "list"
  )

  # wrong level
  expect_null(
    icos_products(
      'http://meta.icos-cp.eu/resources/stations/ES_SE-Nor',
      level = 6
      )
  )

})

test_that("citation checks",{
  skip_on_cran()

  dobj <- "https://meta.icos-cp.eu/objects/lNJPHqvsMuTAh-3DOvJejgYc"

  # download the data
  expect_type(
    icos_citation(dobj = dobj),
    "list"
  )

  # download the data
  expect_type(
    icos_citation(doi = "10.18160/CS8J-MF3U"),
    "list"
  )

  # no dobj
  expect_null(
    icos_citation()
  )

})

test_that("download checks",{
  skip_on_cran()

  dobj <- "https://meta.icos-cp.eu/objects/lNJPHqvsMuTAh-3DOvJejgYc"

  # download the data
  expect_message(
    icos_download(dobj = dobj, verbose = FALSE)
  )

  # no dobj
  expect_null(
    icos_download()
  )

})





