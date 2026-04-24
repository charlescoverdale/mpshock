# GSS path factor (Swanson extended)

The Forward Guidance factor from Swanson's (2021) three-factor
decomposition of high-frequency FOMC surprises, the direct extension of
the original "path" factor in Gurkaynak, Sack, and Swanson (2005).
Event-level factor values are summed within calendar months; months with
no scheduled FOMC meeting are coded as zero.

## Usage

``` r
gss_path
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. GSS path factor, percentage points.

- series:

  `character`. Series identifier `"gss_path"`.

## Source

Swanson, E. T. (2021). "Measuring the Effects of Federal Reserve Forward
Guidance and Asset Purchases on Financial Markets." *Journal of Monetary
Economics* 118: 32-53.
[doi:10.1016/j.jmoneco.2020.09.003](https://doi.org/10.1016/j.jmoneco.2020.09.003)
. Data: <https://sites.socsci.uci.edu/~swanson2/>.

## Details

See
[gss_target](https://charlescoverdale.github.io/mpshock/reference/gss_target.md)
for identification, rotation sensitivity, and aggregation details; the
same caveats apply to both factors since they come from a joint
rotation.

**Regime coverage.** The path factor picks up forward-guidance surprises
and is the most informative Swanson factor during the zero-lower-bound
period (2009 to 2015). Its variance rises sharply in that window
relative to the pre-ZLB sample, consistent with forward guidance
becoming the dominant policy tool.
