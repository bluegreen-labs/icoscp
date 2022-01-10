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
library(SPARQL)

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
  expect_error(
    icos_stations(station = "FR-To")
    )
})
