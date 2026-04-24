# Nakamura-Steinsson policy news shock

The monthly policy news shock series from Nakamura and Steinsson (2018).
Each monthly observation is the sum of high-frequency FOMC-event
surprises occurring within the month. The surprise at each FOMC
announcement is the first principal component of changes in five
interest-rate futures (Fed Funds and Eurodollar) in a 30-minute window
bracketing the announcement. Months with no scheduled FOMC meeting are
coded as zero.

## Usage

``` r
nakamura_steinsson
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. Policy news shock, scaled to one-year Treasury-yield
  equivalents (percentage points).

- series:

  `character`. Series identifier `"nakamura_steinsson"`.

## Source

Nakamura, E., & Steinsson, J. (2018). "High-Frequency Identification of
Monetary Non-Neutrality: The Information Effect." *Quarterly Journal of
Economics* 133(3): 1283-1330.
[doi:10.1093/qje/qjy004](https://doi.org/10.1093/qje/qjy004) .
Replication archive on Harvard Dataverse:
<https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN>
(CC0 1.0 Universal public domain dedication).

## Details

**Scaling.** The raw first principal component is rescaled so that a
unit change equals the contemporaneous change in the one-year nominal
Treasury yield (NS Section II.B). Magnitudes are therefore not directly
comparable to Kuttner (2001) basis-point fed-funds surprises or to raw
FF1 / FF4 surprises without rescaling.

**Interpretation caveat.** NS frame their policy-news shock as evidence
of a "Fed information effect": hawkish surprises raise private-sector
growth forecasts. Bauer and Swanson (2023, AER 113(3)) argue the pattern
is better explained by the Fed and professional forecasters reacting to
the same pre-meeting public data ("Fed response to news"). Users
estimating causal macro effects of policy should consider
[bauer_swanson](https://charlescoverdale.github.io/mpshock/reference/bauer_swanson.md)
(MPS_ORTH) or
[miranda_agrippino_ricco](https://charlescoverdale.github.io/mpshock/reference/miranda_agrippino_ricco.md)
as alternatives that address this bias.

**Unscheduled meetings.** Inter-meeting cuts (notably 22 January 2008
and 8 October 2008) are included in the series and drive a large share
of sample variance.
