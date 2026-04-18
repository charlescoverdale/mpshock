# mpshock

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

Monetary policy shock and stance series for the United States, United Kingdom, and Australia, bundled in R.

## What is a monetary policy shock?

When the Fed, Bank of England, or ECB announces a rate decision, part of the move is expected by markets and part is not. The unexpected part is what economists call a **monetary policy shock**: an exogenous change in policy that lets empirical macroeconomists separate the causal effect of policy from policy's response to the economy. Every paper running an impulse response function (IRF), local projection (LP), vector autoregression (VAR), or event study needs a shock series as its identifying input. Shadow-rate measures play the same role during zero-lower-bound episodes, when the policy rate itself is pinned at its floor.

Those series live today as XLS and CSV files scattered across individual authors' personal pages, Federal Reserve research data pages, and GitHub mirrors, with inconsistent column names, date formats, and update cadences. Over three decades the methodology for measuring these shocks has evolved: from narrative reading of FOMC minutes (Romer and Romer 2004), to high-frequency identification around announcement windows (Kuttner 2001; Gurkaynak, Sack, and Swanson 2005; Nakamura and Steinsson 2018), to sign-restricted decompositions of joint rate-and-stock moves (Jarocinski and Karadi 2020), to orthogonalisation against pre-announcement public data or the Fed's Greenbook forecasts (Bauer and Swanson 2023; Miranda-Agrippino and Ricco 2021). Shadow-rate term-structure models (Wu and Xia 2016) address the zero-lower-bound regime separately. Each technique produces a subtly different series, and modern empirical papers increasingly report impulse responses under several as a robustness check.

`mpshock` centralises these series as tidy data frames with provenance, loaded in one call, no network required.

## Who is this for?

`mpshock` is for empirical macroeconomists, central-bank research staff, rates strategists, and PhD students. Typical uses are supplying the identifying input to a local projection, VAR, proxy-SVAR, or event study of asset-price responses to FOMC, MPC, or RBA announcements. If your specification needs an exogenous monetary policy shock, this package supplies it.

## Installation

```r
# Once accepted by CRAN
install.packages("mpshock")

# Development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/mpshock")
```

## Walkthrough

Every call into `mpshock` follows the same pattern: ask for a series by name, then work with it as a tidy data frame. Here's a guided tour through the main functions. Output shown with `#>` prefix is what you will see in your console.

### 1. See what's available

```r
# Attach the package
library(mpshock)

# mp_list() returns a metadata table with one row per bundled series
# (we select a subset of columns here for a readable display)
mp_list()[, c("series", "author", "type", "start", "end", "n")]
#>                    series                                           author        type      start        end   n
#> 1      nakamura_steinsson                    Nakamura and Steinsson (2018)       shock 2000-02-01 2014-03-01 170
#> 2           bauer_swanson                         Bauer and Swanson (2023)       shock 1988-02-01 2023-12-01 431
#> 3              gss_target Gurkaynak, Sack, Swanson (2005) / Swanson (2021)       shock 1991-07-01 2015-10-01 292
#> 4                gss_path Gurkaynak, Sack, Swanson (2005) / Swanson (2021)       shock 1991-07-01 2015-10-01 292
#> 5    jarocinski_karadi_mp                     Jarocinski and Karadi (2020)       shock 1990-02-01 2024-01-01 404
#> 6   jarocinski_karadi_cbi                     Jarocinski and Karadi (2020) information 1990-02-01 2024-01-01 404
#> 7 miranda_agrippino_ricco               Miranda-Agrippino and Ricco (2021)       shock 1991-01-01 2019-06-01 342
#> 8                  wu_xia                                Wu and Xia (2016) shadow_rate 1960-01-01 2022-02-01 385
```

### 2. Load a series

```r
# Load the Nakamura-Steinsson policy news shock into the object `ns`
ns <- mp_shock("nakamura_steinsson")

# head() shows the first six rows plus a provenance header
head(ns)
#> <mp_shock> nakamura_steinsson [monthly, 6 obs, 2000-02-01 to 2000-07-01]
#>        date      shock
#>  2000-02-01  0.0215744
#>  2000-03-01 -0.0028683
#>  2000-04-01  0.0000000
#>  2000-05-01  0.0335943
#>  2000-06-01 -0.0061341
#>  2000-07-01  0.0000000
```

`ns` is an `mp_shock` object (inherits from `data.frame`). It has a `date` column set to the first day of each month and a `shock` column in percentage points. Months with no FOMC meeting are coded zero, matching the convention in Gertler-Karadi (2015) and the authors' maintained releases.

### 3. Check the citation

```r
# mp_source() prints the paper, DOI, source URL, and method description
mp_source("nakamura_steinsson")
#> nakamura_steinsson
#>   Nakamura and Steinsson (2018)
#>   DOI: 10.1093/qje/qjy004
#>   URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN
#>   Policy news shock: first principal component of five interest-rate futures
#>   surprises in a 30-minute window around FOMC announcements, aggregated to
#>   monthly.
```

Always cite the underlying paper when you use a series in academic work. See [Citation](#citation) for the full list.

### 4. Filter by date window

```r
# Subset to the 2008 financial-crisis months using start and end arguments
crisis <- mp_shock("nakamura_steinsson",
                   start = "2008-01-01",
                   end   = "2008-06-30")
head(crisis)
#> <mp_shock> nakamura_steinsson [monthly, 6 obs, 2008-01-01 to 2008-06-01]
#>        date      shock
#>  2008-01-01 -0.0692382
#>  2008-02-01  0.0000000
#>  2008-03-01  0.2043770
#>  2008-04-01 -0.0755810
#>  2008-05-01  0.0000000
#>  2008-06-01 -0.0252113
```

The January and March 2008 rows capture the inter-meeting 75-basis-point cuts that stand out as the largest surprises of the GFC window.

### 5. Aggregate to quarterly

```r
# Aggregate the monthly series to quarterly by summing within each quarter
ns_q <- mp_to_quarterly(ns, method = "sum")

head(ns_q)
#> <mp_shock> nakamura_steinsson [quarterly, 6 obs, 2000-01-01 to 2001-04-01]
#>        date      shock
#>  2000-01-01  0.0187061
#>  2000-04-01  0.0274602
#>  2000-07-01  0.0126884
#>  2000-10-01  0.0537947
#>  2001-01-01 -0.1058595
#>  2001-04-01  0.0328807
```

`method = "mean"` (arithmetic mean within the quarter) and `method = "end"` (last month's value, used for stock-like series such as the Wu-Xia shadow rate) are also supported.

### 6. Compute a running cumulative shock

```r
# mp_cumulate() adds a `shock_cum` column with the running cumulative sum
ns_cum <- mp_cumulate(ns)
head(ns_cum)
#> <mp_shock> nakamura_steinsson [monthly, 6 obs, 2000-02-01 to 2000-07-01]
#>        date      shock shock_cum
#>  2000-02-01  0.0215744 0.0215744
#>  2000-03-01 -0.0028683 0.0187061
#>  2000-04-01  0.0000000 0.0187061
#>  2000-05-01  0.0335943 0.0523004
#>  2000-06-01 -0.0061341 0.0461663
#>  2000-07-01  0.0000000 0.0461663
```

Pass `window = 12L` for a rolling 12-month sum instead.

### 7. Multi-column series (Wu-Xia)

Not every bundled series has a single shock column. The Wu-Xia shadow rate carries three data columns: the first-differenced `shock` for pipeline compatibility, the level `shadow_rate`, and the effective federal funds rate `effr` for reference.

```r
# Load the Wu-Xia shadow rate over the first GFC zero-lower-bound episode
wx <- mp_shock("wu_xia", start = "2008-01-01", end = "2008-06-30")

head(wx)
#> <mp_shock> wu_xia [monthly, 6 obs, 2008-01-01 to 2008-06-01]
#>        date       shock shadow_rate effr
#>  2008-01-01 -1.04279824    2.655856 3.22
#>  2008-02-01 -0.51799019    2.137866 3.01
#>  2008-03-01 -0.26333728    1.874529 2.51
#>  2008-04-01 -0.06210523    1.812423 2.37
#>  2008-05-01  0.14401369    1.956437 1.98
#>  2008-06-01  0.09757498    2.054012 2.47
```

## Example: comparing alternative shock series

A common robustness check: run the same regression with different identification strategies and see whether the impulse responses line up. Here's how to line up two shock series on a common monthly grid.

```r
# Load two alternative US monetary policy shocks over the same window
ns <- mp_shock("nakamura_steinsson", start = "2005-01-01", end = "2013-12-31")
bs <- mp_shock("bauer_swanson",      start = "2005-01-01", end = "2013-12-31")

# Merge by date; attach suffixes so the two shock columns can be told apart
panel <- merge(
  ns[, c("date", "shock")],       # NS shock series
  bs[, c("date", "shock")],       # BS orthogonalised surprise
  by = "date",
  suffixes = c("_ns", "_bs")
)

head(panel)

# Pearson correlation of the two shock series over the common sample
cor(panel$shock_ns, panel$shock_bs, use = "pairwise.complete.obs")
```

A correlation in the 0.4 to 0.7 range is typical: the series agree on the biggest FOMC surprises but diverge on the harder-to-classify meetings. Papers should report IRF results under at least two shock series for robustness (Aeberhardt, Bruno, and Fidora 2024, FEDS working paper).

## Series included in v0.1.0

### United States

| Series | Author(s) | Type | Frequency | Span |
|---|---|---|---|---|
| `nakamura_steinsson` | Nakamura and Steinsson (2018) | Identified shock | Monthly | 2000-02 to 2014-03 |
| `bauer_swanson` | Bauer and Swanson (2023) | Orthogonalised surprise | Monthly | 1988-02 to 2023-12 |
| `gss_target` | Swanson (2021), GSS (2005) | Target factor | Monthly | 1991-07 to 2015-10 |
| `gss_path` | Swanson (2021), GSS (2005) | Forward-guidance factor | Monthly | 1991-07 to 2015-10 |
| `jarocinski_karadi_mp` | Jarocinski and Karadi (2020) | Pure MP shock | Monthly | 1990-02 to 2024-01 |
| `jarocinski_karadi_cbi` | Jarocinski and Karadi (2020) | CB information shock | Monthly | 1990-02 to 2024-01 |
| `miranda_agrippino_ricco` | Miranda-Agrippino and Ricco (2021) | Info-robust MP shock | Monthly | 1991-01 to 2019-06 |
| `wu_xia` | Wu and Xia (2016) | Shadow rate (stance) | Monthly | 1960-01 to 2022-02 |

### United Kingdom

| Series | Author(s) | Type | Frequency | Span |
|---|---|---|---|---|
| `ukmpd` | Braun, Miranda-Agrippino, Saha (2025) | Three-factor HFI (Target / Path / QE) | Monthly | 1997-06 onwards (BoE-maintained) |
| `cesa_bianchi_uk` | Cesa-Bianchi, Thwaites, Vicondoa (2020) | High-frequency surprise | Monthly | 1997-06 to 2015-01 |
| `cloyne_hurtgen_uk` | Cloyne and Hurtgen (2016) | Narrative shock | Monthly | 1997-06 to 2009-02 |

### Australia

| Series | Author(s) | Type | Frequency | Span |
|---|---|---|---|---|
| `hambur_haque_au` | Hambur and Haque (2023) | Three-component HFI (action / path / term premium) | Monthly | 2001-04 to 2019-12 |
| `beckers_au` | Beckers (2020) | Narrative shock (Bishop-Tulip + credit spreads) | Quarterly | 1994-Q1 to 2018-Q4 |

The Wu-Xia series ends in February 2022 because the Atlanta Fed paused the update once policy rates normalised. The series remains the standard reference for the two zero-lower-bound episodes (2008-12 to 2015-12 and 2020-03 to 2022-02). The UKMPD is live-maintained by the Bank of England and is the flagship UK source for post-1997 work.

## Methodology notes

Users should be aware of a few caveats. Each per-series help file (`?nakamura_steinsson`, `?bauer_swanson`, etc.) discusses these in more depth.

- **Shock versus surprise.** "Surprise" refers to the raw market reaction to an announcement (e.g. NS first principal component, raw Bauer-Swanson MPS); "shock" refers to the exogenous structural component after removing predictable public information (e.g. MPS_ORTH, Miranda-Agrippino-Ricco residual, Jarocinski-Karadi MP). `mpshock` uses `shock` as a column name for pipeline uniformity; consult each series' docs for what the underlying object is.
- **Information-effect debate.** The Nakamura-Steinsson (2018) "Fed information effect" interpretation is challenged by Bauer and Swanson (2023, AER) and Miranda-Agrippino and Ricco (2021). When estimating macro IRFs, MPS_ORTH (`bauer_swanson`) and the informationally-robust shock (`miranda_agrippino_ricco`) are the current methodological leaders; NS and JK-MP remain widely cited.
- **Monthly aggregation.** All event-study series are aggregated to calendar-month by summation; months with no FOMC meeting are coded zero. Bu, Rogers, and Wu (2021, JME) recommend coding no-meeting months as `NA` for proxy-SVAR/LP-IV to avoid downward-biased variance. `mpshock` does not apply this; apply post hoc if needed.
- **Wu-Xia sensitivity.** Shadow-rate estimates depend on the lower-bound choice, number of factors, and yield maturities (Krippner 2020, JMCB). Robustness to Krippner's alternative SSR is recommended for any result that relies on the shadow-rate level.

## Planned for future versions

* Euro-area shocks: Jarocinski-Karadi ECB version, Altavilla et al. (2019) Euro-Area Monetary Policy Database.
* Romer and Romer (2004) US narrative shocks.
* Bolhuis, Das, and Yao (2024 IMF WP) cross-country panel of 29 central banks' HFI shocks.
* A vignette reproducing a Gertler-Karadi (2015) style impulse response using `mpshock` plus `lpirfs`.
* Aeberhardt, Bruno, and Fidora (2024) cross-series comparison helper.

## Functions

| Function | Purpose |
|---|---|
| `mp_shock()` | Load a named series as a tidy data frame |
| `mp_list()` | Metadata table of available series |
| `mp_source()` | Citation and source URL for a series |
| `mp_align()` | Align a series to a target data frame by date |
| `mp_to_quarterly()` | Aggregate monthly series to quarterly |
| `mp_cumulate()` | Cumulative or rolling-window shock sums |

## Citation

Cite both the package and the underlying paper(s) for the series you use. Package citation:

```r
citation("mpshock")
```

Series citations:

| Series | Reference | DOI |
|---|---|---|
| `nakamura_steinsson` | Nakamura and Steinsson (2018). *Quarterly Journal of Economics* 133(3): 1283-1330. | [10.1093/qje/qjy004](https://doi.org/10.1093/qje/qjy004) |
| `bauer_swanson` | Bauer and Swanson (2023). *American Economic Review* 113(3): 664-700. | [10.1257/aer.20200994](https://doi.org/10.1257/aer.20200994) |
| `gss_target`, `gss_path` | Swanson (2021). *Journal of Monetary Economics* 118: 32-53. | [10.1016/j.jmoneco.2020.09.003](https://doi.org/10.1016/j.jmoneco.2020.09.003) |
| `jarocinski_karadi_mp`, `jarocinski_karadi_cbi` | Jarocinski and Karadi (2020). *AEJ: Macroeconomics* 12(2): 1-43. | [10.1257/mac.20180090](https://doi.org/10.1257/mac.20180090) |
| `miranda_agrippino_ricco` | Miranda-Agrippino and Ricco (2021). *AEJ: Macroeconomics* 13(3): 74-107. | [10.1257/mac.20180124](https://doi.org/10.1257/mac.20180124) |
| `wu_xia` | Wu and Xia (2016). *Journal of Money, Credit and Banking* 48(2-3): 253-291. | [10.1111/jmcb.12300](https://doi.org/10.1111/jmcb.12300) |
| `ukmpd` | Braun, Miranda-Agrippino, and Saha (2025). *Journal of Monetary Economics* 149. | [10.1016/j.jmoneco.2024.103670](https://doi.org/10.1016/j.jmoneco.2024.103670) |
| `cesa_bianchi_uk` | Cesa-Bianchi, Thwaites, and Vicondoa (2020). *European Economic Review* 123: 103375. | [10.1016/j.euroecorev.2020.103375](https://doi.org/10.1016/j.euroecorev.2020.103375) |
| `cloyne_hurtgen_uk` | Cloyne and Hurtgen (2016). *AEJ: Macroeconomics* 8(4): 75-102. | [10.1257/mac.20150093](https://doi.org/10.1257/mac.20150093) |
| `hambur_haque_au` | Hambur and Haque (2023, RDP 2023-04); published in *Economic Record* 2024. | [10.1111/1475-4932.12786](https://doi.org/10.1111/1475-4932.12786) |
| `beckers_au` | Beckers (2020). RBA Research Discussion Paper 2020-01. | [link](https://www.rba.gov.au/publications/rdp/2020/2020-01/) |

Original two-factor GSS: Gurkaynak, Sack, and Swanson (2005), *International Journal of Central Banking* 1(1): 55-93.

## Related packages

| Package | What it covers |
|---|---|
| [`fred`](https://github.com/charlescoverdale/fred) | Federal Reserve Economic Data (US macro inputs for IRFs and LPs) |
| [`nowcast`](https://github.com/charlescoverdale/nowcast) | Economic nowcasting with bridge equations |
| [`inflationkit`](https://github.com/charlescoverdale/inflationkit) | CPI decomposition, persistence, Phillips curve |
| [`yieldcurves`](https://github.com/charlescoverdale/yieldcurves) | Nelson-Siegel and Svensson yield curves |
| [`readecb`](https://github.com/charlescoverdale/readecb) | European Central Bank data (Euro-area IRF panels) |
| [`boe`](https://github.com/charlescoverdale/boe) | Bank of England data (UK rates and financial conditions) |

## Issues and requests

Report bugs or request additional series at [GitHub Issues](https://github.com/charlescoverdale/mpshock/issues). Pull requests for new series are welcome; please include a licensing check in the PR description.

## Keywords

monetary policy, impulse response, local projection, high-frequency identification, FOMC, shocks, shadow rate, empirical macroeconomics.
