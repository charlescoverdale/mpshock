# Hambur-Haque Australian monetary policy shock

High-frequency monetary policy surprise for Australia, decomposed into
three components (action, path, and term premium) by a principal-
component rotation of changes in overnight-indexed swap and Australian
Government Securities yields around RBA cash-rate decisions. Monthly
frequency; months with no RBA board meeting are coded zero.

## Usage

``` r
hambur_haque_au
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. Action factor (current cash-rate surprise), percentage
  points.

- action:

  `numeric`. Current-meeting cash-rate surprise, percentage points.

- path:

  `numeric`. Forward-guidance surprise, percentage points.

- term_premium:

  `numeric`. Long-end term-premium surprise, percentage points.

- series:

  `character`. Series identifier `"hambur_haque_au"`.

## Source

Hambur, J., & Haque, Q. (2023). "Monetary Policy Transmission, Real
Interest Rates and Credit Spreads: Evidence from Australia." *Economic
Record* (2024).
[doi:10.1111/1475-4932.12786](https://doi.org/10.1111/1475-4932.12786) .
Data: Reserve Bank of Australia Research Discussion Paper 2023-04,
<https://www.rba.gov.au/publications/rdp/2023/2023-04/>. CC BY 4.0.

## Details

**Identification.** Three PC components are rotated to isolate (i)
`action`, the current-meeting cash-rate surprise; (ii) `path`, the
forward-guidance surprise in expected short rates; (iii) `term_premium`,
the residual long-end move attributable to duration / term-premium
effects. `shock` is set to `action` for pipeline compatibility; users
running multi-factor IRFs should use the individual component columns.

**Coverage.** The bundled series spans April 2001 to December 2019,
matching the published paper. The RBA has not released a maintained
extension covering the COVID-era LSAP period.

**Licence.** Published as an RBA Research Discussion Paper under
Commonwealth of Australia Creative Commons Attribution 4.0 International
licence.
