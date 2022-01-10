context("test icoscp queries")

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
