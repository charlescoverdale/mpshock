# Cesa-Bianchi-Thwaites-Vicondoa UK high-frequency shock

High-frequency monetary policy surprise for the United Kingdom,
constructed from tight-window changes in the three-month sterling
interbank rate around Bank of England MPC announcements. Kuttner-style
identification adapted for the UK. Monthly frequency.

## Usage

``` r
cesa_bianchi_uk
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. UK HFI surprise, percentage points.

- series:

  `character`. Series identifier `"cesa_bianchi_uk"`.

## Source

Cesa-Bianchi, A., Thwaites, G., & Vicondoa, A. (2020). "Monetary policy
transmission in the United Kingdom: A high frequency identification
approach." *European Economic Review* 123: 103375.
[doi:10.1016/j.euroecorev.2020.103375](https://doi.org/10.1016/j.euroecorev.2020.103375)
. Data: <https://sites.google.com/site/ambropo/publications>.

## Details

**Identification.** Surprises are extracted as the change in the
three-month sterling interbank rate in a 60-minute window around each
MPC announcement, isolating the unexpected component of the policy
decision. Event-level values are aggregated to monthly by summation;
months with no MPC meeting are coded zero.

**Superseded.** For the same identification strategy with a richer
asset-price menu and ongoing maintenance, use
[ukmpd](https://charlescoverdale.github.io/mpshock/reference/ukmpd.md).
The CTV series remains useful as a historical reference and for
comparisons with pre-UKMPD empirical literature.

**Vintage.** Static at the published version (1997-06 to 2015-01). No
extension maintained by the authors.
