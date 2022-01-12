# icoscp <a href='https://bluegreen-labs.github.io/icoscp/'><img src='https://raw.githubusercontent.com/bluegreen-labs/icoscp/master/logo.png' align="right" height="139" /></a>

[![R-CMD-check](https://github.com/bluegreen-labs/icoscp/workflows/R-CMD-check/badge.svg)](https://github.com/bluegreen-labs/icoscp/actions)
[![codecov](https://codecov.io/gh/bluegreen-labs/icoscp/branch/master/graph/badge.svg)](https://codecov.io/gh/bluegreen-labs/icoscp)

A programmatic interface to the Integrated Carbon Observation System (ICOS) [Carbon Portal](https://www.icos-cp.eu/). Allows for easy downloads of ICOS carbon portal data directly to your R 
work space or your computer.

This package is a partial port of the [`icoscp` python package](https://github.com/ICOS-Carbon-Portal/pylib), retaining for now the functions relating to downloading site meta-data, available data and
the eventual downloading of the data. Unlike the icoscp pacakge
the subsetting of the data products or collections should be done by the user.

Further differences pertain to the downloaded data, which can not be directly
inspected and is often downloaded as a (zipped) binary. These files can be
easily unzipped using conventional or internal `R` tools.

## Installation

### stable release

No CRAN releases yet - should be there soonish!

### development release

To install the development releases of the package run the following
commands:

``` r
if(!require(devtools)){install.packages("devtools")}
devtools::install_github("bluegreen-labs/icoscp")
library("icoscp")
```

Vignettes are not rendered by default, if you want to include additional
documentation please use:

``` r
if(!require(devtools)){install.packages("devtools")}
devtools::install_github("bluegreen-labs/icoscp", build_vignettes = TRUE)
library("icoscp")
```

## Use

### Listing ICOS stations

The package provides easy access to data and meta-data. You can quickly list all
the ICOS stations using the following command.

``` r
stations <- icos_stations()
```

### Listing ICOS collections

The package provides easy access to data and meta-data. You can quickly list all
the ICOS stations using the following command.

``` r
collections <- icos_collections()
```

For more examples see the package vignettes.

## Citation

Hufkens K. 2022. The 'icoscp' package: An R interface with the ICOS Carbon
Portal data services.

## Acknowledgements

This work has been supported by [BlueGreen Labs](https://bluegreenlabs.org) 
and the Schmidt Futures Initiative Land Ecosystem Models based On New Theory, 
obseRvations, and ExperimEnts (LEMONTREE) project.

