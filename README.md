# icoscp <a href='https://bluegreen-labs.github.io/icoscp/'><img src='https://raw.githubusercontent.com/bluegreen-labs/icoscp/master/logo.png' align="right" height="139" /></a>

[![R-CMD-check](https://github.com/bluegreen-labs/icoscp/workflows/R-CMD-check/badge.svg)](https://github.com/bluegreen-labs/icoscp/actions)
[![codecov](https://codecov.io/gh/bluegreen-labs/icoscp/branch/master/graph/badge.svg)](https://codecov.io/gh/bluegreen-labs/icoscp)

A programmatic interface to the [ICOS Carbon Portal](https://www.icos-cp.eu/). Allows for easy downloads of ICOS carbon portal data directly to your R workspace or your computer.

*This is a work in progress and should not yet be used. Keep an eye on the project for future full releases.*

## Installation

### stable release

No CRAN releases yet

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

Coming soon.

## Citation

Hufkens K.

## Acknowledgements

This work has been supported by BlueGreen Labs and the LEMONTREE project.

