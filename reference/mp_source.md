# Citation and provenance for a shock series

Returns a single-row data frame with the author, DOI, source URL, and
short description for the named series. Also prints the citation to the
console.

## Usage

``` r
mp_source(series)
```

## Arguments

- series:

  Character(1). Name of the series. See
  [`mp_list()`](https://charlescoverdale.github.io/mpshock/reference/mp_list.md)
  for available series.

## Value

Invisibly, a one-row data frame with columns `series`, `author`, `doi`,
`source_url`, `description`.

## Examples

``` r
mp_source("nakamura_steinsson")
#> nakamura_steinsson
#>   Nakamura and Steinsson (2018)
#>   DOI: 10.1093/qje/qjy004
#>   URL:
#>   https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN
#>   Policy news shock: first principal component of five interest-rate futures
#>   surprises in a 30-minute window around FOMC announcements, aggregated to
#>   monthly.
```
