# CRAN submission comments: mpshock 0.1.0

## New submission

This is a new package providing a curated collection of monetary policy
shock and stance series from the empirical macroeconomics literature.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Test suite

40+ expectations. No tests access the network; all data is bundled.

## Data access and provenance

All series are bundled as compressed R data under `data/`. Upstream
sources (author replication files on Harvard Dataverse and Federal
Reserve Bank of Atlanta research data page) are documented in
`data-raw/` scripts, which are not run at build or load time. Each
bundled dataset carries provenance metadata (author, DOI, source URL,
download date, licence) accessible via `mp_source()`.

Data licensing:
* `nakamura_steinsson`: CC0 1.0 Universal public domain dedication
  (Harvard Dataverse doi:10.7910/DVN/HZOXKN).
* `wu_xia`: US Federal Reserve research output, not subject to
  copyright under 17 U.S.C. s. 105.

## Downstream dependencies

None.
