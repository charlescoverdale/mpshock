# Bauer-Swanson orthogonalised monetary policy surprise

The monthly orthogonalised monetary policy surprise series (MPS_ORTH)
from Bauer and Swanson (2023), with the raw MPS alongside. The
orthogonalised series removes predictability from public economic
information available before each FOMC meeting, isolating a genuinely
exogenous monetary-policy innovation.

## Usage

``` r
bauer_swanson
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. Orthogonalised MPS, percentage points.

- mps_raw:

  `numeric`. Raw high-frequency MPS summed within the month, percentage
  points.

- series:

  `character`. Series identifier `"bauer_swanson"`.

## Source

Bauer, M. D., & Swanson, E. T. (2023). "A Reassessment of Monetary
Policy Surprises and High-Frequency Identification." *NBER
Macroeconomics Annual* 37: 87-155.
[doi:10.1086/723574](https://doi.org/10.1086/723574) . Data:
<https://www.frbsf.org/research-and-insights/data-and-indicators/monetary-policy-surprises/>.

## Details

**Orthogonalisation.** MPS_ORTH is the OLS residual from regressing the
raw MPS on six pre-announcement predictors: surprise in the most recent
nonfarm payrolls release, trailing 12-month employment growth, log S&P
500 change over the prior three months, change in the 10-year minus
2-year Treasury slope over the same window, log commodity-price- index
change, and Bauer-Chernov option-implied 10-year Treasury skewness. See
Bauer and Swanson (2023) Appendix Table A.1 for exact predictor
definitions and data sources.

**Relation to
[nakamura_steinsson](https://charlescoverdale.github.io/mpshock/reference/nakamura_steinsson.md).**
Both series use a first principal component of tight-window futures
surprises. MPS_ORTH additionally removes predictability from public
data, which Bauer- Swanson argue isolates the policy shock from the "Fed
response to news" that NS attribute to a Fed information effect.

**Critique.** Hoesch, Rossi, and Sekhposyan (2023) show alternative
orthogonalisation choices yield different residuals. If the Fed has any
informational advantage, the orthogonalisation throws it away by
construction.

**Vintage.** Bundled from the FRBSF-maintained update covering through
December 2023. For a frozen vintage, download directly from the source
URL in
[`mp_source()`](https://charlescoverdale.github.io/mpshock/reference/mp_source.md).
