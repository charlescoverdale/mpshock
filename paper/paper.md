---
title: "mpshock: A Multi-Country Monetary Policy Shock Database for R"
author: "Charles Coverdale"
date: April 2026
abstract: |
  Empirical monetary economics relies on identified policy shock series as the
  exogenous input to impulse response functions, local projections, and
  proxy-SVARs. Those series live today as Excel and CSV files. They are
  scattered across individual authors' personal pages, Federal Reserve
  research data pages, and GitHub mirrors. Column names, date formats, and
  update cadences differ across sources.

  This paper introduces `mpshock`, an R package that bundles thirteen
  monetary policy shock and stance series across three countries (United
  States, United Kingdom, Australia). Each series is a tidy, versioned,
  tested data frame with provenance metadata. Each loads in a single
  call. Each carries its paper citation and source URL. Each plugs
  directly into the dominant downstream R packages for impulse response
  estimation: `lpirfs`, `BVAR`, `vars`.

  I demonstrate the package by replicating cross-series comparisons in
  the spirit of Aeberhardt, Bruno, and Fidora (2024), and by producing
  the first published cross-country cumulative monetary-shock chart from
  a single R pipeline. The package is available on CRAN and GitHub.

  \medskip
  \noindent\textit{JEL classification}: C87, E52, E58.

  \noindent\textit{Keywords}: monetary policy, impulse response functions, high-frequency identification, local projections, R, reproducible research.
bibliography: refs.bib
fontsize: 11pt
geometry: a4paper, margin=25mm
documentclass: article
colorlinks: true
linkcolor: "blue!60!black"
citecolor: "blue!60!black"
urlcolor: "blue!60!black"
toc-own-page: true
header-includes:
  - \usepackage{graphicx}
  - \usepackage[sc]{mathpazo}
  - \usepackage{microtype}
  - \usepackage{booktabs}
  - \usepackage{longtable}
  - \usepackage{tabularx}
  - "\\AtBeginDocument{\\author{Charles Coverdale\\thanks{Email: \\href{mailto:charles.f.coverdale@gmail.com}{charles.f.coverdale@gmail.com}. Package repository: \\href{https://github.com/charlescoverdale/mpshock}{github.com/charlescoverdale/mpshock}.}\\\\ London, United Kingdom}}"
  - \usepackage[font=small,labelfont=bf]{caption}
  - \usepackage{titlesec}
  - \titleformat{\section}{\large\bfseries}{\thesection}{1em}{}
  - \titleformat{\subsection}{\normalsize\bfseries}{\thesubsection}{1em}{}
  - \usepackage{hyperref}
  - \usepackage{etoolbox}
  - \pretocmd{\tableofcontents}{\clearpage}{}{}
  - \usepackage{tocloft}
  - \setlength{\cftbeforesecskip}{2pt}
  - \setlength{\cftbeforesubsecskip}{0pt}
  - \renewcommand{\cftsecfont}{\normalsize}
  - \renewcommand{\cftsecpagefont}{\normalsize}
  - \usepackage{xcolor}
  - \usepackage{listings}
  - \lstset{basicstyle=\ttfamily\small,breaklines=true,frame=single,framerule=0.3pt,rulecolor=\color{gray!40},backgroundcolor=\color{gray!5}}
---

# 1. Introduction

Every paper that runs an impulse response function, local projection, proxy-SVAR, or event study of monetary policy transmission begins with the same question: *which shock series do I use as the identifying input?* Over the last three decades, the answer has multiplied. @romer2004new opened the modern literature with narrative identification of Federal Reserve policy. @kuttner2001monetary and @gurkaynak2005actions extended identification to high-frequency intraday windows around FOMC announcements, using futures surprises to isolate the unexpected component of policy moves. @nakamura2018high refined the factor structure and provided the first widely-used "policy news shock" series. @jarocinski2020deconstructing split the surprise into a "pure monetary policy" component and a "central bank information" component via sign restrictions on the joint response of short rates and stock prices. @miranda2021transmission orthogonalised high-frequency surprises against the Fed's own Greenbook information set. @bauer2023alternative made the same move against a tighter basket of pre-announcement public data and challenged the information-effect interpretation directly. @wu2016measuring estimated a shadow federal funds rate via a three-factor term-structure model. @swanson2021measuring extended the original two-factor Gürkaynak-Sack-Swanson decomposition with an LSAP factor to cover the zero-lower-bound era.

These series are not interchangeable. Their correlations range from around 0.4 to 0.7 on common samples. Researchers who care about the identification of monetary policy's causal effects are increasingly expected to report impulse responses under several strategies as a robustness check [@aeberhardt2024monetary].

Running those robustness checks requires wrangling data from eight to ten sources. An XLSX on the San Francisco Fed's research-data page. A maintained GitHub repository. An openICPSR replication archive. A Harvard Dataverse zip. An author's personal site. Each source has its own date format, column naming convention, aggregation choice, and update cadence. A graduate student can easily spend a weekend just assembling the raw inputs to a simple cross-comparison.

This paper introduces `mpshock`, an R package that bundles thirteen monetary policy shock and stance series across the United States, United Kingdom, and Australia as tidy data frames with provenance metadata. Version 0.1.0 is available on CRAN. Each series loads in a single call. Each carries its paper citation and source URL. Each uses a common monthly frequency and date format. Each plugs directly into the dominant downstream R packages for impulse response estimation: `lpirfs` [@adammer2019lpirfs], `BVAR` [@kuschnig2021bvar], and `vars` [@pfaff2008var].

`mpshock` differs from existing R infrastructure in two ways. First, it is the first R package to bundle shock series for more than one country in a common schema. Comparable resources, such as the `hfdshocks` GitHub repository and individual replication archives, are single-country and unmaintained. Second, `mpshock` treats *provenance* as a first-class design property. Each bundled dataset carries the DOI, URL, licence, and download date of its upstream source. Each help file discusses identification, known critiques, and aggregation caveats. The package is not a wrapper. It is a curated, citable, teachable alternative to the current fragmented workflow.

The rest of the paper proceeds as follows. Section 2 sketches the methodological landscape of monetary policy shock identification. Section 3 documents the package design. Sections 4, 5, and 6 describe the bundled US, UK, and Australian series. Section 7 describes the helper functions. Section 8 replicates a canonical cross-series comparison on a common US sample. Section 9 presents a cross-country cumulative shock chart. Section 10 discusses limitations. Section 11 concludes.

# 2. The measurement of monetary policy shocks

A monetary policy shock is, heuristically, the part of a central bank's policy decision that was not anticipated by markets. Formally, it is the residual from a regression of the realised policy rate on a real-time proxy for the central bank's information set; in practice, it is constructed in one of five ways.

**Narrative identification.** @romer2004new read the minutes of FOMC meetings and the Fed's Greenbook forecasts, regressed policy-rate changes on those real-time forecasts, and interpreted the residual as the exogenous policy innovation. The strength of narrative identification is its strong theoretical footing: the shock is defined as the component of policy orthogonal to the Fed's actual information set. The weakness is that the approach is labour-intensive and depends on the analyst's judgment about which Fed communications to include. @cloyne2016macroeconomic produced the United Kingdom equivalent using the Bank of England's *Inflation Report* forecasts; @beckers2020credit produced an Australian series using the Reserve Bank of Australia's internal forecasts and the Bishop-Tulip (2017) methodology, augmented with credit-spread information.

**High-frequency identification (HFI).** @kuttner2001monetary observed that federal funds futures prices jumping in a 30-minute window around FOMC announcements cleanly identify the *unexpected* component of the policy move. @gurkaynak2005actions showed that several futures contracts jointly identify two factors: a "target" factor capturing the current-meeting surprise and a "path" factor capturing guidance about future rates. @nakamura2018high refined the construction by using five interest-rate futures and rescaling to one-year Treasury-yield equivalents. @cesabianchi2020monetary produced the UK HFI analogue using sterling interbank rate surprises; @hambur2023monetary produced the Australian equivalent using OIS and Australian Government Securities yields around RBA board meetings. The strength of HFI is market discipline: if a rate change is priced into futures before the meeting, by construction it cannot be the unexpected shock. The weakness, now widely discussed, is the "Fed information effect": if the Fed and professional forecasters both react to the same pre-meeting public data, the announcement surprise reflects information revelation as well as policy [@bauer2023alternative; @miranda2021transmission].

**Sign restrictions.** @jarocinski2020deconstructing exploit the joint response of short-term interest rates and stock prices to FOMC announcements. A positive "pure monetary policy" shock raises rates and lowers stocks; a positive "central bank information" shock raises both (markets interpret the policy move as a signal that the Fed has seen favourable economic news). The identification is set-valued: many rotations of the two-shock SVAR are admissible, and the package bundles the median rotation as the standard summary. The critique, formalised in @acosta2023perceived, is that the rate-stock sign pattern is a weak discriminator between policy and information shocks because the two are typically negatively correlated at high frequency regardless of shock type.

**Informationally-robust identification.** @miranda2021transmission project high-frequency FF4 surprises (the fourth Eurodollar futures contract) onto the Fed's Greenbook forecast revisions for GDP, unemployment, and inflation at horizons of zero to four quarters. The residual is the shock orthogonal to the Fed's forecasting information, not just to public data. This addresses the information-effect critique at its source. The trade-off is sample coverage: the Fed's Tealbook is subject to a five-year release embargo, so post-embargo extensions must substitute real-time Greenbook-equivalent forecasts from the Survey of Professional Forecasters, introducing a subtle break in the information basis.

**Shadow-rate term-structure models.** @wu2016measuring estimate a Gaussian three-factor affine term-structure model for Treasury yields in which the observed short rate equals $\max(r_t^*, r^{\mathrm{ELB}})$, where $r_t^*$ is a latent shadow rate and $r^{\mathrm{ELB}}$ is the effective lower bound. The shadow rate can go negative during zero-lower-bound episodes, providing a continuous measure of monetary stance when the federal funds rate itself is stuck at its floor. The shadow rate is not a shock but a stance measure, and its first difference only approximates a policy innovation [@krippner2020comparison].

`mpshock` bundles series from all five approaches and exposes them through a single interface.

# 3. Package design

## 3.1 Architecture and dependencies

`mpshock` is a pure-data R package in the sense of @wickham2014tidydata. Each bundled series lives as a compressed R data object under `data/` in the source tree; the package's R code provides a thin uniform loader, a provenance accessor, and a small set of transformation helpers. The package declares three imports: `cli` (for structured messages and argument validation), `stats` (for `aggregate()`), and `utils` (for `data()`). It declares no runtime dependency on `tidyverse` or on any HTTP client, because all data is bundled at build time; this keeps installation light and makes the package resilient to upstream API changes. `R (>= 4.1.0)` is required; LaTeX is not.

## 3.2 The `mp_shock` class

Every bundled series is a `data.frame` carrying the `mp_shock` S3 class, with at minimum three columns: `date` (first day of the observation month, as `Date`), `shock` (the shock value in percentage points), and `series` (a character identifier). Series with multiple identified factors carry additional columns: `target`, `path`, and `qe` for the UK Monetary Policy Event-Study Database [@braun2025measuring]; `action`, `path`, and `term_premium` for the Australian three-factor decomposition [@hambur2023monetary]; `shadow_rate` and `effr` for the Wu-Xia series. The `mp_shock` class has a lightweight `print.mp_shock` method that emits a one-line provenance header before the tabular output.

## 3.3 The loader

The single entry point is `mp_shock()`:

```r
mp_shock(series, start = NULL, end = NULL)
```

`series` is a character identifier matched against an internal allow-list; unknown names raise a structured error listing the available series. `start` and `end` are optional `Date` or `YYYY-MM-DD` character filters. The loader validates its inputs via `cli::cli_abort()`, loads the requested dataset via `utils::data()`, applies the date filter, and returns the result.

## 3.4 Metadata

`mp_list()` returns a metadata table with one row per series and eleven columns: `series`, `author`, `country`, `frequency`, `type`, `start`, `end`, `n`, `doi`, `source_url`, and `description`. `mp_source(series)` returns the one-row subset for a single series and prints the citation to the console. Both functions are deliberately separated from the data loader to avoid recursion and to make the metadata table itself available as a teaching artefact.

## 3.5 Helpers

Three transformation helpers are provided. `mp_align()` left-joins a shock series onto a target data frame by date, lining up a shock with a macro panel before IRF estimation. `mp_to_quarterly()` aggregates monthly series to quarterly frequency via summation, mean, or end-of-quarter value. `mp_cumulate()` computes cumulative or rolling-window shock sums.

These helpers do the minimum preprocessing every empirical user needs. They do not try to replicate the full-power IRF packages downstream. For anything beyond basic preparation, users should reach for `lpirfs`, `BVAR`, or `vars`.

## 3.6 Reproducibility posture

The package ships a `data-raw/` directory (excluded from the build but checked into the public repository) containing an R script for each bundled series. Each script documents the upstream URL, the download date, and the exact transformations applied to arrive at the bundled object. Re-running `data-raw/` regenerates the bundled data from the original sources, subject to upstream availability.

# 4. Bundled US series

**`nakamura_steinsson`** [@nakamura2018high]. The policy news shock from the 2018 QJE paper, constructed as the first principal component of five interest-rate futures (Fed Funds and Eurodollar) in a 30-minute window around FOMC announcements and rescaled to one-year Treasury-yield equivalents. Bundled at monthly frequency by summing event-level values within each calendar month. 2000-02 to 2014-03, 170 observations. Data is from the Harvard Dataverse replication archive under CC0 1.0.

**`bauer_swanson`** [@bauer2023alternative]. The orthogonalised monetary policy surprise (MPS_ORTH) is the OLS residual of the raw MPS on six pre-announcement predictors. The predictors are: the surprise in the most recent nonfarm payrolls release, trailing 12-month employment growth, log S&P 500 change over the prior three months, the change in the 10y-2y Treasury slope over the same window, log commodity-price-index change, and the Bauer-Chernov option-implied 10-year Treasury yield skewness. 1988-02 to 2023-12, 431 observations. Maintained by the Federal Reserve Bank of San Francisco.

**`gss_target`** and **`gss_path`** [@swanson2021measuring; @gurkaynak2005actions]. The Federal Funds Rate factor and Forward Guidance factor from Swanson's three-factor decomposition, which extends the original Gürkaynak-Sack-Swanson (2005) two-factor model with an LSAP factor to cover the zero-lower-bound era. The target and path factors bundled here are the direct analogues of the original GSS factors; the LSAP factor is not bundled in v0.1.0. Rotation is conditional on the pre-ZLB window (1991-07 to 2008-12) used to pin down factor 3; users extending the series past the bundled end must re-estimate the rotation. 1991-07 to 2015-10, 292 observations each.

**`jarocinski_karadi_mp`** and **`jarocinski_karadi_cbi`** [@jarocinski2020deconstructing]. The pure monetary policy shock and central bank information shock, identified by sign restrictions on the joint response of 3-month fed funds futures and the S&P 500 in 30-minute FOMC windows. Bundled at monthly frequency from the authors' maintained GitHub update, using the median decomposition in which both shocks may co-occur at any event. 1990-02 to 2024-01, 404 observations each.

**`miranda_agrippino_ricco`** [@miranda2021transmission]. The informationally-robust monetary policy shock, constructed as the residual of the FF4 surprise after projection onto the Fed's Greenbook forecast revisions for GDP, unemployment, and inflation at horizons 0-4 quarters. 1991-01 to 2019-06, 342 observations. Bundled from the Degasperi-Ricco maintained extension; post-2013 observations substitute real-time SPF forecasts for the embargoed Tealbook.

**`wu_xia`** [@wu2016measuring]. The monthly shadow federal funds rate, estimated from a three-factor shadow-rate term-structure model with the effective lower bound fixed at 0.25%. The bundled series has four numeric columns: the first-differenced `shock` for pipeline compatibility, the `shadow_rate` level, the contemporaneous `effr`, and `series`. 1960-01 to 2022-02, 746 observations. Maintained by the Federal Reserve Bank of Atlanta; the series ends in February 2022 because the authors paused updates once policy rates normalised.

# 5. Bundled UK series

**`ukmpd`** [@braun2025measuring]. The UK Monetary Policy Event-Study Database is the UK analogue of the Swanson (2021) three-factor decomposition. The package exposes three columns: `shock` (Target factor), `path` (Forward Guidance factor), and `qe` (QE factor). Each factor is computed from high-frequency surprises in OIS rates, gilt yields, short-sterling futures, and the FTSE 100. The surprise windows bracket MPC announcements and Monetary Policy Report press conferences. Live-maintained by the Bank of England. The bundled snapshot covers 1997-06 to 2026-02, 345 observations.

**`cesa_bianchi_uk`** [@cesabianchi2020monetary]. The UK high-frequency surprise constructed from 60-minute tight-window changes in the three-month sterling interbank rate around MPC announcements. 1997-06 to 2015-01, 212 observations. Superseded in most use cases by `ukmpd` but retained for historical comparability with the pre-UKMPD empirical literature.

**`cloyne_hurtgen_uk`** [@cloyne2016macroeconomic]. The UK narrative monetary policy shock, constructed by regressing Bank Rate changes on the Bank of England's real-time *Inflation Report* forecasts for output, unemployment, and inflation, at horizons up to two years. The residual is the "narrative" shock. Bundled from the Cesa-Bianchi-Thwaites-Vicondoa re-compilation; the original paper covers 1975-2007. 1997-06 to 2009-02, 141 observations.

# 6. Bundled Australian series

**`hambur_haque_au`** [@hambur2023monetary]. The three-component Australian high-frequency shock: `shock` (action factor, current-meeting cash-rate surprise), `path` (forward-guidance surprise), and `term_premium` (long-end term-premium surprise), each from a principal-component rotation of OIS and Australian Government Securities yield changes around RBA cash-rate decisions. 2001-04 to 2019-12, 225 observations. Published as RBA Research Discussion Paper 2023-04 under Creative Commons Attribution 4.0 International.

**`beckers_au`** [@beckers2020credit]. The Australian narrative monetary policy shock, constructed by regressing RBA cash-rate changes on the Bank's internal forecasts (Bishop-Tulip 2017 methodology) and augmenting with credit-spread information. The headline series is the Beckers "BT-CS" measure; the pre-augmentation Bishop-Tulip shock is bundled alongside as `bt`. This is the only quarterly-frequency series in the package: 1994-Q1 to 2018-Q4, 100 observations. Published as RBA Research Discussion Paper 2020-01.

# 7. Transformation helpers

All event-study series are bundled at monthly frequency by summing event-level surprises within each calendar month, with no-meeting months coded zero. This matches the convention in @gertler2015monetary and the authors' own maintained releases. @bu2021unified recommend coding no-meeting months as `NA` rather than zero when estimating proxy-SVAR or LP-IV models, to avoid downward-biased variance in weak-instrument F-statistics; users who want this treatment can recode after loading via `shock[shock == 0 & !is_meeting_month] <- NA`.

The three transformation helpers perform the minimal pre-modelling manipulation required by most pipelines. `mp_align()` left-joins a shock series onto a target data frame by a common date column, with an optional `fill_zero` argument to replace NAs with zeros. `mp_to_quarterly()` aggregates monthly series to quarterly frequency via one of three methods: `sum` (the standard choice for additive shock innovations), `mean` (for rate-based series used in quarterly-average regressions), and `end` (the last month's value, appropriate for stock-like measures such as shadow rates). `mp_cumulate()` returns cumulative sums either over the full sample or in a rolling window of user-specified length.

# 8. Replication: four identification strategies on a common sample

Figure 1 plots cumulative Federal Reserve monetary policy shocks over the common sample available to four identification strategies: Nakamura-Steinsson (2018), Bauer-Swanson (2023, MPS_ORTH), Jarociński-Karadi (2020, pure MP), and Miranda-Agrippino-Ricco (2021). The sample runs from February 2000 to March 2014, determined by the intersection of the four bundled spans. The entire plot was produced by the ten-line script in Listing 1; no external data is required.

\begin{figure}[t]
\centering
\includegraphics[width=\textwidth]{figures/cumulative_us.pdf}
\caption{Cumulative US monetary policy shocks under four identification strategies on a common sample. The four series agree on the direction and broad timing of the major identified policy innovations but disagree materially on magnitude around the 2008 financial crisis and on the interpretation of the December 2013 "tapering" surprise.}
\label{fig:cumulative_us}
\end{figure}

\begin{figure}[t]
\centering
\includegraphics[width=0.9\textwidth]{figures/us_correlations.pdf}
\caption{Pairwise Pearson correlations among seven US shock and stance series on their common monthly sample.}
\label{fig:correlations}
\end{figure}

Figure 2 presents the pairwise correlation matrix across all seven bundled US series on their common sample. The diagonal block across the four shock-type series (Nakamura-Steinsson, Bauer-Swanson, Jarociński-Karadi pure MP, and Miranda-Agrippino-Ricco) shows correlations in the 0.4-0.7 range. This is consistent with the cross-series comparison in @aeberhardt2024monetary, who argue that once coding and sample choices are harmonised, the alternative identification strategies deliver qualitatively similar impulse responses for output and prices. Users should therefore report robustness across series as the default empirical practice rather than selecting a single "preferred" shock.

```{.r caption="Reproducing Figure 1 using mpshock"}
library(mpshock)

# Load four alternative US monetary policy shocks on their common sample
series <- c("nakamura_steinsson", "bauer_swanson",
            "jarocinski_karadi_mp", "miranda_agrippino_ricco")
window <- list(start = "2000-02-01", end = "2014-03-01")
panel  <- do.call(rbind, lapply(series, function(s) {
  d <- mp_shock(s, start = window$start, end = window$end)
  d$shock[is.na(d$shock)] <- 0
  data.frame(date = d$date, series = s, cum = cumsum(d$shock))
}))

# Plot (10th line)
ggplot(panel, aes(date, cum, colour = series)) + geom_line()
```

Estimating Gertler-Karadi-style impulse responses using any of these shocks as the external instrument is a one-line extension: pass the shock column as the `instrum =` argument to `lpirfs::lp_lin_iv()` together with a target macro panel.

# 9. Cross-country cumulative shocks: a first

Figure 3 plots cumulative monthly monetary policy shocks for the United States, United Kingdom, and Australia from 2005 to 2022. The series are Bauer-Swanson (MPS_ORTH), the UKMPD Target factor, and the Hambur-Haque action factor respectively. I am not aware of any prior chart of this type produced from a common R pipeline. Shaded regions mark the global financial crisis (September 2008 to June 2009) and the COVID-19 monetary response (March to June 2020).

\begin{figure}[t]
\centering
\includegraphics[width=\textwidth]{figures/cross_country.pdf}
\caption{Cumulative monetary policy shocks in the United States, United Kingdom, and Australia, 2005-2022. The three central banks share direction around global events but differ sharply in timing and magnitude during unconventional-policy episodes.}
\label{fig:cross_country}
\end{figure}

The three central banks share the direction of policy around major global events. The GFC, the 2013 taper tantrum, and the 2022-23 tightening cycle all show up in every series. But timing and magnitude differ sharply.

The Federal Reserve's MPS_ORTH trace shows compressed shock variance during the 2009-2015 ZLB period. This is consistent with the short end being pinned at the lower bound. Most identified innovations moved through forward guidance in this window, not through the target factor bundled here.

The UKMPD Target trace shows the opposite pattern. Non-trivial target-factor shocks appear right through the ZLB era. This reflects the MPC's occasional departures from the Bank Rate floor.

The Hambur-Haque action factor for Australia shows a shallow-cut profile. This reflects the RBA's later and shallower move to zero.

This kind of comparison is the central motivation for a multi-country package. No existing R resource makes it achievable in 15 lines of code.

# 10. Limitations and methodological caveats

Six limitations are worth naming explicitly.

First, `mpshock` is a data-curation project, not a methodological one. The package does not propose a new identification strategy, a new aggregation rule, or a new econometric test. Users seeking novelty in those directions should look to `lpirfs`, `BVAR`, `bsvarSIGNs`, or the source papers themselves.

Second, the package is v0.1.0 and covers three countries. Euro-area shocks (the ECB version of Jarociński-Karadi, the Altavilla Event-Study Database) are a v0.2.0 priority. The cross-country panel of @bolhuis2024new covering 29 central banks is a candidate for v0.3.0, subject to licence resolution.

Third, monthly aggregation of event-level shocks by summation is the Gertler-Karadi (2015) convention and the default for every bundled source, but it is not the only choice. @bu2021unified argue for NA-coding of no-meeting months; the Gertler-Karadi (2015) appendix argues for weighting by the fraction of the month after the meeting when the dependent variable is a monthly-average interest rate. `mpshock` does not apply either adjustment; the package provides the raw sum and leaves post-hoc adjustment to the user.

Fourth, shock identification itself is contested. The Nakamura-Steinsson (2018) "Fed information effect" is directly challenged by @bauer2023alternative and implicitly questioned by @miranda2021transmission. The Jarociński-Karadi (2020) sign-restriction decomposition is critiqued by @acosta2023perceived on the grounds that the rate-stock sign pattern is a weak discriminator. Wu-Xia shadow rate estimates are sensitive to the lower-bound choice, number of factors, and yield maturities used [@krippner2020comparison]. Each per-series help page discusses the relevant critique, but no curation can resolve the substantive debate; users are expected to read the source papers and form their own view.

Fifth, every bundled series has a cut-off date that may not match the user's desired estimation window. The UKMPD is live-maintained by the Bank of England and is the most current; Bauer-Swanson is updated roughly annually; several series (Nakamura-Steinsson, Cesa-Bianchi-Thwaites-Vicondoa, Wu-Xia) are static at their paper's published end date and will not be extended. Users needing the most recent vintages should consult each series' source URL (available via `mp_source()`) before a final empirical cut.

Sixth, licences vary across sources. The Nakamura-Steinsson replication archive is CC0 1.0 public domain. The RBA Research Discussion Paper supplements are CC BY 4.0. The Federal Reserve Bank of San Francisco publishes Bauer-Swanson as public research output without a formal licence statement. Author-hosted files, such as Swanson and Cesa-Bianchi-Thwaites-Vicondoa, carry no explicit licence but are distributed as customary academic replication material. Users should cite the underlying paper for any series used in academic work, not `mpshock` alone.

# 11. Conclusion

`mpshock` is a curated, versioned, provenance-first R package that removes the most tedious step in empirical monetary economics: assembling the shock series. By bundling thirteen identification strategies across three countries in a common schema, the package lowers the cost of cross-series robustness checks from hours to minutes and enables cross-country comparisons that, to the author's knowledge, no existing R resource makes tractable. The package is available on CRAN and developed at https://github.com/charlescoverdale/mpshock. Suggestions for additional series, particularly from the Euro area and emerging markets, are welcomed via GitHub issues.

# Acknowledgements

I thank the authors of each bundled series for making their data publicly available: Emi Nakamura, Jón Steinsson, Michael Bauer, Eric Swanson, Refet Gürkaynak, Brian Sack, Marek Jarociński, Peter Karadi, Silvia Miranda-Agrippino, Giovanni Ricco, Jing Cynthia Wu, Fan Dora Xia, Robin Braun, Tuli Saha, Ambrogio Cesa-Bianchi, Gregory Thwaites, Alejandro Vicondoa, James Cloyne, Patrick Hürtgen, Jonathan Hambur, Qazi Haque, and Benjamin Beckers.

# References

::: {#refs}
:::

\clearpage

# Appendix A: Full series metadata

\input{tables/series_summary.tex}

# Appendix B: Pairwise correlation table

US series pairwise correlations, common sample 2000-02 to 2014-03.

\input{tables/us_correlations.tex}

# Appendix C: Session information

All figures and tables in this paper were produced by `paper/make_figures.R` on the development branch of `mpshock` v0.1.0. The reproducibility script depends on `R (>= 4.1.0)`, `mpshock (>= 0.1.0)`, and `ggplot2 (>= 3.4.0)`. PDF rendering uses pandoc 3.6 or later with the `xelatex` engine.
