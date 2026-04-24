# Align a shock series to a target data frame by date

Left-joins a shock series onto a target data frame by its date column.
Non-matching target rows receive `NA` in the shock column. Use this to
line a shock series up with a macro panel before running impulse
responses or local projections.

## Usage

``` r
mp_align(shock, target, by = "date", fill_zero = FALSE)
```

## Arguments

- shock:

  An `mp_shock` object from
  [`mp_shock()`](https://charlescoverdale.github.io/mpshock/reference/mp_shock.md).

- target:

  A data frame containing a date column.

- by:

  Character(1). The name of the date column in `target`. Defaults to
  `"date"`.

- fill_zero:

  Logical(1). If `TRUE`, non-matching target rows get `0` in the shock
  column instead of `NA`. Useful when the target is a complete monthly
  panel and missing shocks should be treated as zero-surprise months.
  Defaults to `FALSE`.

## Value

A data frame with the same rows as `target` plus a `shock` column (and
any other numeric columns from the shock series, prefixed with the
series name).

## Examples

``` r
panel <- data.frame(
  date = seq(as.Date("2010-01-01"), as.Date("2010-06-01"), by = "month"),
  gdp_growth = rnorm(6)
)
aligned <- mp_align(mp_shock("nakamura_steinsson"), panel)
head(aligned)
#>         date   gdp_growth      shock
#> 1 2010-01-01 -1.400043517  0.0266820
#> 2 2010-02-01  0.255317055  0.0000000
#> 3 2010-03-01 -2.437263611 -0.0239221
#> 4 2010-04-01 -0.005571287 -0.0012485
#> 5 2010-05-01  0.621552721  0.0000000
#> 6 2010-06-01  1.148411606  0.0120140
```
