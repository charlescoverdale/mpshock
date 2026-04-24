# Beckers Australian narrative monetary policy shock

Narrative Romer-Romer-style monetary policy shock for Australia. RBA
cash-rate changes are purged of their systematic response to the Bank's
internal forecasts (Bishop-Tulip 2017 methodology) and further augmented
with credit-spread information to separate genuine policy innovations
from responses to financial conditions. Quarterly frequency. The
headline bundled `shock` is Beckers's preferred credit-spread-augmented
series ("BT-CS"); the pre-augmentation Bishop-Tulip series (`bt`) is
included alongside for comparison.

## Usage

``` r
beckers_au
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation quarter.

- shock:

  `numeric`. BT-CS shock (preferred), percentage points.

- bt:

  `numeric`. Bishop-Tulip pre-augmentation shock, percentage points.

- rate_chg:

  `numeric`. Raw quarterly cash-rate change, percentage points.

- series:

  `character`. Series identifier `"beckers_au"`.

## Source

Beckers, B. (2020). "Credit Spreads, Monetary Policy and the Price
Puzzle in Australia." Reserve Bank of Australia Research Discussion
Paper 2020-01. <https://www.rba.gov.au/publications/rdp/2020/2020-01/>.
CC BY 4.0. Bishop-Tulip methodology: Bishop, J., & Tulip, P. (2017).
"Anticipatory Monetary Policy and the Price Puzzle." RBA Research
Discussion Paper 2017-02.

## Details

**Construction.** The BT-CS series regresses cash-rate changes on RBA
internal forecasts (GDP, unemployment, CPI) plus measures of domestic
credit spreads, at quarterly frequency. The residual is the identified
policy shock.

**Frequency note.** This is the only quarterly-frequency series
currently bundled in `mpshock`.
[`mp_to_quarterly()`](https://charlescoverdale.github.io/mpshock/reference/mp_to_quarterly.md)
is unnecessary; pass `beckers_au` directly into quarterly VARs or LPs.

**Licence.** RBA research output under Creative Commons Attribution 4.0
International.
