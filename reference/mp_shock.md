# Load a monetary policy shock series

Loads a named shock series bundled with the package as a tidy data frame
with class `mp_shock`. Optionally filters by date range.

## Usage

``` r
mp_shock(series, start = NULL, end = NULL)
```

## Arguments

- series:

  Character(1). Name of the series. See
  [`mp_list()`](https://charlescoverdale.github.io/mpshock/reference/mp_list.md)
  for available series.

- start, end:

  Optional `Date` or character (YYYY-MM-DD) filters on the returned
  series. If `NULL`, returns the full bundled span.

## Value

A data frame with class `c("mp_shock", "data.frame")` and columns:

- `date`: `Date`, first day of the observation month.

- `shock`: `numeric`, the shock value in the units published by the
  source (see
  [`mp_source()`](https://charlescoverdale.github.io/mpshock/reference/mp_source.md)
  and the per-series help files for units and scaling conventions).

- `series`: `character`, the series identifier.

Some series carry additional columns.
[bauer_swanson](https://charlescoverdale.github.io/mpshock/reference/bauer_swanson.md)
returns `mps_raw` alongside `shock` (the orthogonalised surprise);
[miranda_agrippino_ricco](https://charlescoverdale.github.io/mpshock/reference/miranda_agrippino_ricco.md)
returns `info`;
[wu_xia](https://charlescoverdale.github.io/mpshock/reference/wu_xia.md)
returns `shadow_rate` and `effr`.

## Details

**Aggregation.** All event-study series
([nakamura_steinsson](https://charlescoverdale.github.io/mpshock/reference/nakamura_steinsson.md),
[bauer_swanson](https://charlescoverdale.github.io/mpshock/reference/bauer_swanson.md),
[gss_target](https://charlescoverdale.github.io/mpshock/reference/gss_target.md),
[gss_path](https://charlescoverdale.github.io/mpshock/reference/gss_path.md),
[jarocinski_karadi_mp](https://charlescoverdale.github.io/mpshock/reference/jarocinski_karadi_mp.md),
[jarocinski_karadi_cbi](https://charlescoverdale.github.io/mpshock/reference/jarocinski_karadi_cbi.md),
[miranda_agrippino_ricco](https://charlescoverdale.github.io/mpshock/reference/miranda_agrippino_ricco.md))
are bundled at monthly frequency by summing FOMC-event-level surprises
within each calendar month. Months with no scheduled FOMC meeting are
coded zero, matching the convention in Gertler and Karadi (2015) and the
authors' own maintained releases.

Bu, Rogers, and Wu (2021, *Journal of Monetary Economics* 118) argue
that no-meeting months should be coded `NA` rather than zero when
estimating proxy-SVAR or LP-IV models, to avoid downward-biased variance
in weak-instrument F-statistics. `mpshock` does not apply this
adjustment; recode after loading if needed.

**Scaling.** Units differ across series.
[nakamura_steinsson](https://charlescoverdale.github.io/mpshock/reference/nakamura_steinsson.md)
is rescaled to one-year nominal Treasury-yield equivalents;
[bauer_swanson](https://charlescoverdale.github.io/mpshock/reference/bauer_swanson.md)
and most others are in raw percentage-point surprises. See each series'
help file.

## See also

[`mp_list()`](https://charlescoverdale.github.io/mpshock/reference/mp_list.md),
[`mp_source()`](https://charlescoverdale.github.io/mpshock/reference/mp_source.md),
[`mp_align()`](https://charlescoverdale.github.io/mpshock/reference/mp_align.md),
[`mp_to_quarterly()`](https://charlescoverdale.github.io/mpshock/reference/mp_to_quarterly.md).

## Examples

``` r
ns <- mp_shock("nakamura_steinsson")
head(ns)
#> <mp_shock> nakamura_steinsson [monthly, 6 obs, 2000-02-01 to 2000-07-01]
#>        date      shock
#>  2000-02-01  0.0215744
#>  2000-03-01 -0.0028683
#>  2000-04-01  0.0000000
#>  2000-05-01  0.0335943
#>  2000-06-01 -0.0061341
#>  2000-07-01  0.0000000

# Filter to a specific window
ns_gfc <- mp_shock("nakamura_steinsson",
                   start = "2007-01-01", end = "2009-12-31")
```
