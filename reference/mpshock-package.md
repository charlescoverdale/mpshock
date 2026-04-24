# mpshock: Monetary Policy Shock Series for Empirical Macroeconomics

Provides a curated collection of monetary policy shock and stance series
from the empirical macroeconomics literature, bundled as tidy data
frames with provenance metadata. All data is bundled; no runtime network
access is required.

## Main functions

- [`mp_shock()`](https://charlescoverdale.github.io/mpshock/reference/mp_shock.md)
  loads a named series.

- [`mp_list()`](https://charlescoverdale.github.io/mpshock/reference/mp_list.md)
  returns a metadata table of available series.

- [`mp_source()`](https://charlescoverdale.github.io/mpshock/reference/mp_source.md)
  returns the citation and source URL for a series.

- [`mp_align()`](https://charlescoverdale.github.io/mpshock/reference/mp_align.md)
  aligns a series to a target data frame by date.

- [`mp_to_quarterly()`](https://charlescoverdale.github.io/mpshock/reference/mp_to_quarterly.md)
  aggregates monthly series to quarterly.

- [`mp_cumulate()`](https://charlescoverdale.github.io/mpshock/reference/mp_cumulate.md)
  computes cumulative or rolling-window shock sums.

## Bundled datasets (v0.1.0)

United States:

- [nakamura_steinsson](https://charlescoverdale.github.io/mpshock/reference/nakamura_steinsson.md):
  policy news shock, 2000-02 to 2014-03.

- [bauer_swanson](https://charlescoverdale.github.io/mpshock/reference/bauer_swanson.md):
  orthogonalised MP surprise, 1988-02 to 2023-12.

- [gss_target](https://charlescoverdale.github.io/mpshock/reference/gss_target.md):
  GSS target factor (Swanson extended), 1991-07 to 2015-10.

- [gss_path](https://charlescoverdale.github.io/mpshock/reference/gss_path.md):
  GSS path factor (Swanson extended), 1991-07 to 2015-10.

- [jarocinski_karadi_mp](https://charlescoverdale.github.io/mpshock/reference/jarocinski_karadi_mp.md):
  pure MP shock, 1990-02 to 2024-01.

- [jarocinski_karadi_cbi](https://charlescoverdale.github.io/mpshock/reference/jarocinski_karadi_cbi.md):
  CB information shock, 1990-02 to 2024-01.

- [miranda_agrippino_ricco](https://charlescoverdale.github.io/mpshock/reference/miranda_agrippino_ricco.md):
  informationally-robust MP shock, 1991-01 to 2019-06.

- [wu_xia](https://charlescoverdale.github.io/mpshock/reference/wu_xia.md):
  shadow federal funds rate, 1960-01 to 2022-02.

United Kingdom:

- [ukmpd](https://charlescoverdale.github.io/mpshock/reference/ukmpd.md):
  three-factor UK event-study database (Target / Path / QE), 1997-06 to
  the latest BoE vintage.

- [cesa_bianchi_uk](https://charlescoverdale.github.io/mpshock/reference/cesa_bianchi_uk.md):
  UK high-frequency surprise, 1997-06 to 2015-01.

- [cloyne_hurtgen_uk](https://charlescoverdale.github.io/mpshock/reference/cloyne_hurtgen_uk.md):
  UK narrative shock, 1997-06 to 2009-02.

Australia:

- [hambur_haque_au](https://charlescoverdale.github.io/mpshock/reference/hambur_haque_au.md):
  three-component RBA HFI shock (action / path / term premium), 2001-04
  to 2019-12.

- [beckers_au](https://charlescoverdale.github.io/mpshock/reference/beckers_au.md):
  RBA narrative shock (Bishop-Tulip + credit spreads), quarterly 1994-Q1
  to 2018-Q4.

## Further reading

For general background on shock identification, see Ramey (2016),
"Macroeconomic Shocks and Their Propagation," *Handbook of
Macroeconomics* 2: 71-162. For a recent cross-series comparison of the
identification strategies bundled here, see Aeberhardt, Bruno, and
Fidora (2024), "Monetary Policy Shocks: Data or Methods?" *FEDS Working
Paper* 2024-011.

## See also

Useful links:

- <https://github.com/charlescoverdale/mpshock>

- Report bugs at <https://github.com/charlescoverdale/mpshock/issues>

## Author

**Maintainer**: Charles Coverdale <charlesfcoverdale@gmail.com>
\[copyright holder\]
