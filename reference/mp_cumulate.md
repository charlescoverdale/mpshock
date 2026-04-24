# Cumulate a shock series

Computes running sums of a shock series. With `window = NULL`, returns
the full cumulative sum. With a finite `window`, returns a rolling
window sum of the last `window` observations.

## Usage

``` r
mp_cumulate(shock, window = NULL)
```

## Arguments

- shock:

  An `mp_shock` object from
  [`mp_shock()`](https://charlescoverdale.github.io/mpshock/reference/mp_shock.md).

- window:

  Integer, the rolling window length in observations. If `NULL`
  (default), computes the full cumulative sum.

## Value

A data frame with the same rows as `shock` and a new column `shock_cum`
(full cumulative) or `shock_roll` (rolling window). Other columns are
preserved.

## Examples

``` r
cum <- mp_cumulate(mp_shock("nakamura_steinsson"))
head(cum)
#> <mp_shock> nakamura_steinsson [monthly, 6 obs, 2000-02-01 to 2000-07-01]
#>        date      shock shock_cum
#>  2000-02-01  0.0215744 0.0215744
#>  2000-03-01 -0.0028683 0.0187061
#>  2000-04-01  0.0000000 0.0187061
#>  2000-05-01  0.0335943 0.0523004
#>  2000-06-01 -0.0061341 0.0461663
#>  2000-07-01  0.0000000 0.0461663

roll <- mp_cumulate(mp_shock("nakamura_steinsson"), window = 12)
head(roll, 15)
#> <mp_shock> nakamura_steinsson [monthly, 15 obs, 2000-02-01 to 2001-04-01]
#>        date      shock shock_roll
#>  2000-02-01  0.0215744  0.0215744
#>  2000-03-01 -0.0028683  0.0187061
#>  2000-04-01  0.0000000  0.0187061
#>  2000-05-01  0.0335943  0.0523004
#>  2000-06-01 -0.0061341  0.0461663
#>  2000-07-01  0.0000000  0.0461663
#>  2000-08-01  0.0126884  0.0588547
#>  2000-09-01  0.0000000  0.0588547
#>  2000-10-01  0.0227776  0.0816323
#>  2000-11-01  0.0040101  0.0856424
#> ... 5 more rows. Call `mp_source("nakamura_steinsson")` for citation.
```
