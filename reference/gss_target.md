# GSS target factor (Swanson extended)

The Federal Funds Rate factor from Swanson's (2021) three-factor
decomposition of high-frequency FOMC surprises, the direct extension of
the original "target" factor in Gurkaynak, Sack, and Swanson (2005).
Event-level factor values are summed within calendar months; months with
no scheduled FOMC meeting are coded as zero.

## Usage

``` r
gss_target
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. GSS target factor, percentage points.

- series:

  `character`. Series identifier `"gss_target"`.

## Source

Swanson, E. T. (2021). "Measuring the Effects of Federal Reserve Forward
Guidance and Asset Purchases on Financial Markets." *Journal of Monetary
Economics* 118: 32-53.
[doi:10.1016/j.jmoneco.2020.09.003](https://doi.org/10.1016/j.jmoneco.2020.09.003)
. Data: <https://sites.socsci.uci.edu/~swanson2/>. Original two-factor
decomposition: Gurkaynak, R. S., Sack, B., and Swanson, E. T. (2005),
*International Journal of Central Banking* 1(1): 55-93.

## Details

**Identification.** Swanson (2021) computes the first three principal
components of high-frequency futures surprises, then rotates them by (i)
zero loading of factor 3 on the current-month fed-funds-rate surprise,
(ii) minimum sum of squared factor-3 values over the pre-ZLB sample
1991-07 to 2008-12, and (iii) sign normalisation. The target and path
factors are therefore conditional on the pre-ZLB window used to pin down
factor 3. Extensions past the bundled span must re-estimate the
rotation, not simply append new events.

**Relation to GSS 2005.** Pre-2009 the target factor closely tracks the
original two-factor decomposition of Gurkaynak, Sack, and Swanson
(2005). Post-2009 it differs because unconventional policy announcements
are absorbed by a distinct LSAP factor (not bundled in v0.1.0; see
Swanson's website for the full three-factor panel).

**Monthly aggregation.** Event-level factors are summed within calendar
months. Months with no scheduled FOMC meeting are coded 0. Users who
want to distinguish "no news" from "news = 0" should recode no-meeting
months as `NA` before estimation (Bu, Rogers, and Wu 2021, *Journal of
Monetary Economics* 118).
