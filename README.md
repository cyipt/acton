
<!-- README.md is generated from README.Rmd. Please edit that file -->

## acton

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/cyipt/acton.svg?branch=master)](https://travis-ci.com/cyipt/acton)
[![CircleCI](https://circleci.com/gh/cyipt/acton.svg?style=svg)](https://circleci.com/gh/cyipt/acton)
<!-- badges: end -->

## Introduction

**Acton** is a research project to provide evidence for local
authorities, developers and civil society groups to support planning and
investment in sustainable transport infrastructure in and around new
developments. To make the results of the research more reproducible and
accessible to others, we have also created an R package, which is
described below.

For information about the wider research project, see [The ACTON
project](https://cyipt.github.io/acton/articles/the-acton-project.html)
report.

## Installing the R package

To install the `acton` package, run the following commands in an R
console (see
[here](https://docs.ropensci.org/stats19/articles/stats19-training-setup.html)
for information on installing R):

``` r
install.packages("remotes")
remotes::install_github("cyipt/acton", dependencies = "Suggests")
```

## Setup instructions

To get routes from CycleStreets.net, you will need to set-up an API key
called CYCLESTREETS with `usethis::edit_renviron()`, as documented here:
<https://docs.ropensci.org/stplanr/reference/route_cyclestreets.html#details>

## Brief demo

The package can be used to get data on new developments as follows:

``` r
library(acton)
# data from specific postcode
planning_data = get_planit_data(pcode = "LS2 9JT", limit = 2)
#> Getting data from https://www.planit.org.uk/api/applics/geojson?limit=2&bbox=&end_date=2020-02-03&start_date=2000-02-01&pg_sz=2&pcode=LS2%209JT
planning_data
#> Simple feature collection with 2 features and 16 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -1.55333 ymin: 53.80796 xmax: -1.55333 ymax: 53.80796
#> epsg (SRID):    4326
#> proj4string:    +proj=longlat +datum=WGS84 +no_defs
#> # A tibble: 2 x 17
#>   doc_type name  distance url   description when_updated        authority_id
#>   <chr>    <chr>    <dbl> <chr> <chr>       <dttm>                     <int>
#> 1 PlanApp… Leed…        0 http… Removal of… 2019-07-23 09:45:04          292
#> 2 PlanApp… Leed…        0 http… Two new of… 2019-02-10 20:52:08          292
#> # … with 10 more variables: source_url <chr>, authority_name <chr>, link <chr>,
#> #   postcode <chr>, address <chr>, lat <dbl>, lng <dbl>, start_date <date>,
#> #   uid <chr>, geometry <POINT [°]>
planning_data$name
#> [1] "Leeds/19/03296/LI" "Leeds/19/00584/FU"
planning_data$description
#> [1] "Removal of condition 5 (retention of spiral staircase) of Listed Building Consent 18/03877/LI due to its condition and location"
#> [2] "Two new off road parking spaces, new bin store, and relocation of existing covered cycle store"
```

## Documentation

For a more detailed overview explaining how to use the package see the
[`acton` vignette](https://cyipt.github.io/acton/articles/acton.html).

For results of research into active travel opportunities in and around
new developments in case study regions, see the [`case-studies`
vignette](https://cyipt.github.io/acton/articles/case-studies.html).

For documentation on each of the package’s functions, see the [Reference
page](https://cyipt.github.io/acton/reference/index.html).

## Citing the work

TBC.
