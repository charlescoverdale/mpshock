# Wu-Xia shadow federal funds rate

The monthly Wu-Xia shadow federal funds rate from Wu and Xia (2016),
maintained and published by the Federal Reserve Bank of Atlanta. The
shadow rate is the authors' estimate of what the federal funds rate
would have been during zero-lower-bound episodes (2008-12 to 2015-12 and
2020-03 to 2022-02) had policy rates been allowed to go negative. The
companion effective federal funds rate (`effr`) is included for
reference.

## Usage

``` r
wu_xia
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. First difference of shadow rate (percentage points per
  annum).

- shadow_rate:

  `numeric`. Wu-Xia shadow federal funds rate at last business day of
  the month (percentage points per annum).

- effr:

  `numeric`. Effective federal funds rate at last business day of the
  month (percentage points per annum).

- series:

  `character`. Series identifier `"wu_xia"`.

## Source

Wu, J. C., & Xia, F. D. (2016). "Measuring the Macroeconomic Impact of
Monetary Policy at the Zero Lower Bound." *Journal of Money, Credit and
Banking* 48(2-3): 253-291.
[doi:10.1111/jmcb.12300](https://doi.org/10.1111/jmcb.12300) . Data:
<https://www.atlantafed.org/cqer/research/wu-xia-shadow-federal-funds-rate>.
US Federal Reserve research output; not subject to copyright under 17
U.S.C. s. 105.

## Details

**Stance vs shock.** The shadow rate is a **stance measure**, not a
policy shock. The `shock` column is the first difference of
`shadow_rate` and is provided for pipeline compatibility with other
series in the package. It conflates genuine policy news with Kalman-
filter revisions of the latent state. Users estimating shock IRFs should
prefer an event-study series
([nakamura_steinsson](https://charlescoverdale.github.io/mpshock/reference/nakamura_steinsson.md),
[bauer_swanson](https://charlescoverdale.github.io/mpshock/reference/bauer_swanson.md),
[miranda_agrippino_ricco](https://charlescoverdale.github.io/mpshock/reference/miranda_agrippino_ricco.md))
and reserve `wu_xia` for characterising the zero-lower-bound policy
stance.

**Model sensitivity.** Krippner (2020, *Journal of Money, Credit and
Banking* 52(4)) documents that shadow-rate estimates are sensitive to
the choice of effective lower bound, the number of factors (two versus
three), and the set of yield maturities used in estimation. Wu-Xia's
three-factor shadow-rate term-structure model (SRTSM) and Krippner's
two-factor SSR can differ by 50 to 150 basis points at the 2014 and 2021
troughs. Results that rely on Wu-Xia alone should be replicated with at
least one alternative shadow-rate series.

**Vintage.** This bundled series is the Atlanta Fed monthly update
current as of the package build. Historical values are filtered
estimates and can change when new data arrives; users needing a fixed
vintage should download the archived Atlanta Fed file directly.
