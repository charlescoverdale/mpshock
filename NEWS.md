# mpshock 0.1.0

Initial release. Thirteen monetary policy shock and stance series
bundled across three countries.

## United States (8 series)

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
* `jarocinski_karadi_mp`: pure monetary policy shock from Jarocinski
  and Karadi (2020), monthly 1990-02 to 2024-01.
* `jarocinski_karadi_cbi`: central bank information shock from
  Jarocinski and Karadi (2020), monthly 1990-02 to 2024-01.
* `miranda_agrippino_ricco`: informationally-robust monetary policy
  shock from Miranda-Agrippino and Ricco (2021), monthly 1991-01 to
  2019-06.
* `wu_xia`: shadow federal funds rate from Wu and Xia (2016), monthly
  1960-01 to 2022-02. US Federal Reserve research output, public
  domain.

## United Kingdom (3 series)

* `ukmpd`: UK Monetary Policy Event-Study Database from Braun,
  Miranda-Agrippino, and Saha (2025), three-factor decomposition
  (Target, Path, QE), monthly 1997-06 onwards, live-maintained by the
  Bank of England.
* `cesa_bianchi_uk`: UK high-frequency surprise from Cesa-Bianchi,
  Thwaites, and Vicondoa (2020), monthly 1997-06 to 2015-01.
* `cloyne_hurtgen_uk`: UK narrative monetary policy shock from Cloyne
  and Hurtgen (2016), bundled via the Cesa-Bianchi-Thwaites-Vicondoa
  re-compilation, monthly 1997-06 to 2009-02.

## Australia (2 series)

* `hambur_haque_au`: three-component Australian high-frequency surprise
  (action, path, term premium) from Hambur and Haque (2023, RDP
  2023-04), monthly 2001-04 to 2019-12. RBA research output, CC BY 4.0.
* `beckers_au`: Australian narrative monetary policy shock (Bishop-
  Tulip plus credit spreads) from Beckers (2020, RDP 2020-01),
  quarterly 1994-Q1 to 2018-Q4. RBA research output, CC BY 4.0.

## Functions

* `mp_shock()` loads a named series as a tidy data frame with class
  `mp_shock`.
* `mp_list()` returns a metadata table of available series.
* `mp_source()` returns the citation and source URL for a series.
* `mp_align()` aligns a series to a target data frame by date.
* `mp_to_quarterly()` aggregates monthly series to quarterly frequency.
* `mp_cumulate()` computes cumulative or rolling-window shock sums.
* S3 `print()` and `format()` methods for `mp_shock` objects.
