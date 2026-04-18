# mpshock 0.1.0

Initial release. Eight United States monetary policy shock and stance
series bundled:

* `nakamura_steinsson`: policy news shock from Nakamura and Steinsson
  (2018), monthly 2000-02 to 2014-03. Harvard Dataverse CC0 1.0.
* `bauer_swanson`: orthogonalised monetary policy surprise (MPS_ORTH)
  from Bauer and Swanson (2023), monthly 1988-02 to 2023-12. SF Fed
  research data.
* `gss_target`: Federal Funds Rate factor from the Swanson (2021)
  extension of Gurkaynak, Sack, and Swanson (2005), monthly 1991-07 to
  2015-10.
* `gss_path`: Forward Guidance factor from the Swanson (2021)
  extension, monthly 1991-07 to 2015-10.
* `jarocinski_karadi_mp`: pure monetary policy shock from Jarocinski and
  Karadi (2020), monthly 1990-02 to 2024-01.
* `jarocinski_karadi_cbi`: central bank information shock from Jarocinski
  and Karadi (2020), monthly 1990-02 to 2024-01.
* `miranda_agrippino_ricco`: informationally-robust monetary policy shock
  from Miranda-Agrippino and Ricco (2021), monthly 1991-01 to 2019-06.
* `wu_xia`: shadow federal funds rate from Wu and Xia (2016), monthly
  1960-01 to 2022-02. US Federal Reserve research output, public domain.

## Functions

* `mp_shock()` loads a named series as a tidy data frame with class
  `mp_shock`.
* `mp_list()` returns a metadata table of available series.
* `mp_source()` returns the citation and source URL for a series.
* `mp_align()` aligns a series to a target data frame by date.
* `mp_to_quarterly()` aggregates monthly series to quarterly frequency.
* `mp_cumulate()` computes cumulative or rolling-window shock sums.
* S3 `print()` and `format()` methods for `mp_shock` objects.
