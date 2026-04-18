# CRAN submission comments: mpshock 0.1.0

## New submission

This is a new package providing a curated collection of eight monetary
policy shock and stance series from the empirical macroeconomics
literature, bundled as tidy data frames with provenance metadata.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Test suite

100+ expectations across eight test files. No tests access the network;
all data is bundled.

## Data access and provenance

All series are bundled as compressed R data under `data/`. Upstream
sources (author replication files on Harvard Dataverse, GitHub-hosted
maintained updates, personal academic pages, and Federal Reserve Bank
research data pages) are documented in the `data-raw/` scripts. These
scripts are not run at build or load time and are excluded from the
build via `.Rbuildignore`. Each bundled dataset carries provenance
metadata (author, DOI, source URL, download date, licence note) that is
accessible via `mp_source()`.

Data licensing per series:

* `nakamura_steinsson`: CC0 1.0 Universal public domain dedication
  (Harvard Dataverse doi:10.7910/DVN/HZOXKN).
* `wu_xia`: US Federal Reserve research output, not subject to copyright
  under 17 U.S.C. s. 105.
* `bauer_swanson`: Federal Reserve Bank of San Francisco research data
  page, published as part of public research output. Cite the source
  paper per `mp_source("bauer_swanson")`.
* `gss_target`, `gss_path`: published research derivatives from academic
  pages; redistribution is customary in the replication literature.
  Cite Swanson (2021) and Gurkaynak, Sack, and Swanson (2005).
* `jarocinski_karadi_mp`, `jarocinski_karadi_cbi`: authors' maintained
  GitHub update of the AEJ:Macro replication materials.
* `miranda_agrippino_ricco`: Degasperi and Ricco's maintained GitHub
  extension of the AEJ:Macro replication materials.

## Downstream dependencies

None.
