# Cloyne-Hurtgen UK narrative monetary policy shock

Narrative Romer-Romer-style monetary policy shock for the United
Kingdom. Cash-rate changes are purged of their systematic response to
Bank of England internal forecasts, leaving a series of exogenous policy
innovations. Monthly frequency.

## Usage

``` r
cloyne_hurtgen_uk
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. UK narrative shock, percentage points.

- series:

  `character`. Series identifier `"cloyne_hurtgen_uk"`.

## Source

Cloyne, J., & Hurtgen, P. (2016). "The Macroeconomic Effects of Monetary
Policy: A New Measure for the United Kingdom." *American Economic
Journal: Macroeconomics* 8(4): 75-102.
[doi:10.1257/mac.20150093](https://doi.org/10.1257/mac.20150093) .
Replication data on openICPSR project 114114; bundled vintage is the
Cesa-Bianchi-Thwaites- Vicondoa (2020) re-compilation available at
<https://sites.google.com/site/ambropo/publications>.

## Details

**Narrative identification.** Cloyne and Hurtgen (2016) read the Bank of
England *Inflation Report* forecasts and regress each Bank Rate change
on the Bank's own real-time projections for output, unemployment, and
inflation at horizons up to two years. The residual is the "narrative"
shock. The bundled series is the extension carried forward by
Cesa-Bianchi, Thwaites, and Vicondoa using the same methodology; the
original paper covers 1975 to 2007 but the bundled vintage is the CTV
re-compiled version from 1997-06 onwards.

**Comparison with HFI.** Narrative shocks are typically lower- frequency
than high-frequency event-window surprises and capture broader policy
reassessments. They can differ materially from
[cesa_bianchi_uk](https://charlescoverdale.github.io/mpshock/reference/cesa_bianchi_uk.md)
and
[ukmpd](https://charlescoverdale.github.io/mpshock/reference/ukmpd.md)
even on common sample.
