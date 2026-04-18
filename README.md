# mpshock

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

Monetary policy shock and stance series from the empirical macroeconomics literature, bundled in R.

## What is a monetary policy shock?

When the Fed, Bank of England, or ECB announces a rate decision, part of the move is expected by markets and part is not. The unexpected part is what economists call a monetary policy shock: an exogenous change in policy that lets empirical macroeconomists separate the causal effect of policy from policy's response to the economy. Every paper running an impulse response function, local projection, VAR, or event study needs a shock series as its identifying input. Shadow-rate measures play the same role during zero-lower-bound episodes, when the policy rate itself is pinned at its floor.

## Why this package?

Every paper that runs an impulse response function, local projection, or event study needs an exogenous monetary policy series as its identifying input. Those series live today as XLS and CSV files on individual authors' personal pages and Federal Reserve research data pages, with inconsistent column names, date formats, and update cadences. `mpshock` centralises them as tidy data frames with provenance, loaded in one call, no network required.

## Installation

```r
# Once accepted by CRAN
install.packages("mpshock")

# Development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/mpshock")
```

## Quick start

```r
library(mpshock)

# List all available series
mp_list()

# Load the Nakamura-Steinsson policy news shock
ns <- mp_shock("nakamura_steinsson")
head(ns)

# Check provenance
mp_source("nakamura_steinsson")

# Load the Wu-Xia shadow rate for the zero-lower-bound era
wx <- mp_shock("wu_xia", start = "2008-01-01", end = "2015-12-31")
head(wx)
```

## Worked examples

Find the largest FOMC policy surprises from Bauer-Swanson:

```r
library(mpshock)

bs <- mp_shock("bauer_swanson")
bs[order(-abs(bs$shock)), ][1:5, ]
```

Compare alternative identification strategies over a common window:

```r
ns  <- mp_shock("nakamura_steinsson", start = "2005-01-01", end = "2013-12-31")
jk  <- mp_shock("jarocinski_karadi_mp", start = "2005-01-01", end = "2013-12-31")
mar <- mp_shock("miranda_agrippino_ricco", start = "2005-01-01", end = "2013-12-31")

panel <- merge(
  merge(ns[, c("date", "shock")], jk[, c("date", "shock")],
        by = "date", all = TRUE, suffixes = c("_ns", "_jk")),
  mar[, c("date", "shock")], by = "date", all = TRUE
)
names(panel)[4] <- "shock_mar"
head(panel)
```

Quarterly aggregation and cumulative path of shocks:

```r
ns_q <- mp_to_quarterly(ns, method = "sum")
mp_cumulate(ns_q)
```

Wu-Xia shadow rate vs the effective federal funds rate through the zero-lower-bound era:

```r
wx <- mp_shock("wu_xia", start = "2008-01-01", end = "2015-12-31")
plot(wx$date, wx$shadow_rate, type = "l", col = "red",
     ylab = "Rate (% p.a.)", xlab = "",
     ylim = range(c(wx$shadow_rate, wx$effr), na.rm = TRUE))
lines(wx$date, wx$effr, lty = 2)
legend("topright", c("Shadow rate", "EFFR"),
       col = c("red", "black"), lty = c(1, 2), bty = "n")
```

A full vignette reproducing a Gertler-Karadi style impulse response will ship with v0.2.0.

## Series included in v0.1.0

| Series | Author(s) | Type | Country | Frequency | Span |
|---|---|---|---|---|---|
| `nakamura_steinsson` | Nakamura and Steinsson (2018) | Identified shock | US | Monthly | 2000-02 to 2014-03 |
| `bauer_swanson` | Bauer and Swanson (2023) | Orthogonalised surprise | US | Monthly | 1988-02 to 2023-12 |
| `gss_target` | Swanson (2021), GSS (2005) | Target factor | US | Monthly | 1991-07 to 2015-10 |
| `gss_path` | Swanson (2021), GSS (2005) | Forward-guidance factor | US | Monthly | 1991-07 to 2015-10 |
| `jarocinski_karadi_mp` | Jarocinski and Karadi (2020) | Pure MP shock | US | Monthly | 1990-02 to 2024-01 |
| `jarocinski_karadi_cbi` | Jarocinski and Karadi (2020) | CB information shock | US | Monthly | 1990-02 to 2024-01 |
| `miranda_agrippino_ricco` | Miranda-Agrippino and Ricco (2021) | Info-robust MP shock | US | Monthly | 1991-01 to 2019-06 |
| `wu_xia` | Wu and Xia (2016) | Shadow rate (stance) | US | Monthly | 1960-01 to 2022-02 |

The Wu-Xia series ends in February 2022 because the Atlanta Fed paused the update once policy rates normalised. The series remains the standard reference for the two zero-lower-bound episodes (2008-12 to 2015-12 and 2020-03 to 2022-02).

## Planned for future versions

* Euro-area shocks: Jarocinski-Karadi ECB version and Altavilla et al. (2019) Euro-Area Monetary Policy Database.
* Romer and Romer (2004) narrative shock.
* Full vignette reproducing a Gertler-Karadi (2015) style IRF using `mpshock` + `lpirfs`.

## Functions

| Function | Purpose |
|---|---|
| `mp_shock()` | Load a named series |
| `mp_list()` | Metadata table of available series |
| `mp_source()` | Citation and source URL for a series |
| `mp_align()` | Align a series to a target data frame by date |
| `mp_to_quarterly()` | Aggregate monthly series to quarterly |
| `mp_cumulate()` | Cumulative or rolling-window shock sums |

## Citation

If you use `mpshock` in academic work, please cite both the package and the underlying paper(s) for the series you use. Package citation:

```r
citation("mpshock")
```

Series citations:

* `nakamura_steinsson`: Nakamura, E., and Steinsson, J. (2018). "High-Frequency Identification of Monetary Non-Neutrality: The Information Effect." *Quarterly Journal of Economics* 133(3): 1283-1330. [doi:10.1093/qje/qjy004](https://doi.org/10.1093/qje/qjy004).
* `bauer_swanson`: Bauer, M. D., and Swanson, E. T. (2023). "An Alternative Explanation for the 'Fed Information Effect'." *American Economic Review* 113(3): 664-700. [doi:10.1257/aer.20200994](https://doi.org/10.1257/aer.20200994).
* `gss_target`, `gss_path`: Swanson, E. T. (2021). "Measuring the Effects of Federal Reserve Forward Guidance and Asset Purchases on Financial Markets." *Journal of Monetary Economics* 118: 32-53. [doi:10.1016/j.jmoneco.2020.09.003](https://doi.org/10.1016/j.jmoneco.2020.09.003). Original two-factor decomposition: Gurkaynak, R. S., Sack, B., and Swanson, E. T. (2005). "Do Actions Speak Louder Than Words?" *International Journal of Central Banking* 1(1): 55-93.
* `jarocinski_karadi_mp`, `jarocinski_karadi_cbi`: Jarocinski, M., and Karadi, P. (2020). "Deconstructing Monetary Policy Surprises: The Role of Information Shocks." *American Economic Journal: Macroeconomics* 12(2): 1-43. [doi:10.1257/mac.20180090](https://doi.org/10.1257/mac.20180090).
* `miranda_agrippino_ricco`: Miranda-Agrippino, S., and Ricco, G. (2021). "The Transmission of Monetary Policy Shocks." *American Economic Journal: Macroeconomics* 13(3): 74-107. [doi:10.1257/mac.20180124](https://doi.org/10.1257/mac.20180124).
* `wu_xia`: Wu, J. C., and Xia, F. D. (2016). "Measuring the Macroeconomic Impact of Monetary Policy at the Zero Lower Bound." *Journal of Money, Credit and Banking* 48(2-3): 253-291. [doi:10.1111/jmcb.12300](https://doi.org/10.1111/jmcb.12300).

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
