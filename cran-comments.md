# CRAN submission comments: mpshock 0.1.0

## New submission

This is a new package providing a curated multi-country collection of
thirteen monetary policy shock and stance series for the United States,
United Kingdom, and Australia, bundled as tidy data frames with
provenance metadata.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Test suite

150+ expectations across nine test files. No tests access the network;
all data is bundled.

## Data access and provenance

All series are bundled as compressed R data under `data/`. Upstream
sources (Harvard Dataverse, GitHub-hosted maintained updates, personal
academic pages, Federal Reserve Bank research pages, the Bank of England
working paper series, Reserve Bank of Australia Research Discussion
Papers) are documented in the `data-raw/` scripts. These scripts are not
run at build or load time and are excluded from the build via
`.Rbuildignore`. Each bundled dataset carries provenance metadata
(author, DOI, source URL, download date, licence note) accessible via
`mp_source()`.

Data licensing per series:

United States:

* `nakamura_steinsson`: CC0 1.0 Universal public domain dedication
  (Harvard Dataverse doi:10.7910/DVN/HZOXKN).
* `wu_xia`: US Federal Reserve research output, not subject to copyright
  under 17 U.S.C. s. 105.
* `bauer_swanson`: Federal Reserve Bank of San Francisco research data
  page, published as public research output.
* `gss_target`, `gss_path`: published research derivatives from academic
  pages; redistribution is customary in the replication literature.
* `jarocinski_karadi_mp`, `jarocinski_karadi_cbi`: authors' maintained
  GitHub update of the AEJ:Macro replication materials.
* `miranda_agrippino_ricco`: Degasperi and Ricco's maintained GitHub
  extension of the AEJ:Macro replication materials.

United Kingdom:

* `ukmpd`: Bank of England Staff Working Paper supplement,
  live-maintained by the Bank of England.
* `cesa_bianchi_uk`: author-hosted supplement to the published *European
  Economic Review* article.
* `cloyne_hurtgen_uk`: openICPSR replication archive (project 114114)
  for the published *AEJ:Macroeconomics* article; bundled vintage is
  the Cesa-Bianchi-Thwaites-Vicondoa (2020) re-compilation.

Australia:

* `hambur_haque_au`, `beckers_au`: Reserve Bank of Australia Research
  Discussion Paper supplements, released under Creative Commons
  Attribution 4.0 International (https://www.rba.gov.au/copyright/).

## Downstream dependencies

None.
