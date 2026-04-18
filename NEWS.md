# mpshock 0.1.0

Initial release.

## Shock and stance series bundled

* `nakamura_steinsson`: policy news shock (identified monetary policy
  shock) from Nakamura and Steinsson (2018), monthly 2000-02 to 2014-03,
  United States. Replication file is CC0 1.0 public-domain-dedicated.
* `wu_xia`: shadow federal funds rate from Wu and Xia (2016), monthly
  1960-01 to 2022-02, United States. US Federal Reserve research output,
  not subject to copyright.

## Functions

* `mp_shock()` loads a named series as a tidy data frame with class
  `mp_shock`.
* `mp_list()` returns a metadata table of available series.
* `mp_source()` returns the citation and source URL for a series.
* `mp_align()` aligns a series to a target data frame by date.
* `mp_to_quarterly()` aggregates monthly series to quarterly frequency.
* `mp_cumulate()` computes cumulative or rolling-window shock sums.
* S3 `print()` and `format()` methods for `mp_shock` objects.
