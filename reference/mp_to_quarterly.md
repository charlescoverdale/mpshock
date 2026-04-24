# Aggregate a monthly shock series to quarterly frequency

Converts a monthly `mp_shock` object to quarterly observations using one
of three aggregation methods.

## Usage

``` r
mp_to_quarterly(shock, method = c("sum", "mean", "end"))
```

## Arguments

- shock:

  An `mp_shock` object from
  [`mp_shock()`](https://charlescoverdale.github.io/mpshock/reference/mp_shock.md)
  at monthly frequency.

- method:

  Character(1). One of `"sum"` (the default, usual choice for additive
  shocks), `"mean"` (arithmetic mean of months in the quarter), or
  `"end"` (last month's value, useful for stock-like measures such as
  shadow rates).

## Value

A data frame with one row per quarter, containing a `date` column set to
the first day of the quarter, the aggregated `shock` column, and the
series identifier. Class `c("mp_shock", "data.frame")`.

## Details

**Method selection.** For identified shocks
([nakamura_steinsson](https://charlescoverdale.github.io/mpshock/reference/nakamura_steinsson.md),
[bauer_swanson](https://charlescoverdale.github.io/mpshock/reference/bauer_swanson.md),
[jarocinski_karadi_mp](https://charlescoverdale.github.io/mpshock/reference/jarocinski_karadi_mp.md),
[miranda_agrippino_ricco](https://charlescoverdale.github.io/mpshock/reference/miranda_agrippino_ricco.md)),
`"sum"` is the standard choice because the underlying objects are
additive surprises at FOMC events. For the shadow rate
([wu_xia](https://charlescoverdale.github.io/mpshock/reference/wu_xia.md)),
`"end"` returns end-of-quarter stance and matches the convention used in
most zero-lower-bound regressions. `"mean"` is appropriate when the
dependent variable is itself a quarterly-average interest rate.

**NA handling.** Missing monthly values are dropped within each quarter
before aggregation. If a whole quarter is missing, the result is zero
under `"sum"` / `"mean"` and `NA` under `"end"`.

## Examples

``` r
ns_q <- mp_to_quarterly(mp_shock("nakamura_steinsson"), method = "sum")
head(ns_q)
#> <mp_shock> nakamura_steinsson [quarterly, 6 obs, 2000-01-01 to 2001-04-01]
#>        date      shock
#>  2000-01-01  0.0187061
#>  2000-04-01  0.0274602
#>  2000-07-01  0.0126884
#>  2000-10-01  0.0537947
#>  2001-01-01 -0.1058595
#>  2001-04-01  0.0328807
```
