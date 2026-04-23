#' Nakamura-Steinsson policy news shock
#'
#' The monthly policy news shock series from Nakamura and Steinsson (2018).
#' Each monthly observation is the sum of high-frequency FOMC-event
#' surprises occurring within the month. The surprise at each FOMC
#' announcement is the first principal component of changes in five
#' interest-rate futures (Fed Funds and Eurodollar) in a 30-minute window
#' bracketing the announcement. Months with no scheduled FOMC meeting are
#' coded as zero.
#'
#' @details
#' **Scaling.** The raw first principal component is rescaled so that a
#' unit change equals the contemporaneous change in the one-year nominal
#' Treasury yield (NS Section II.B). Magnitudes are therefore not
#' directly comparable to Kuttner (2001) basis-point fed-funds surprises
#' or to raw FF1 / FF4 surprises without rescaling.
#'
#' **Interpretation caveat.** NS frame their policy-news shock as
#' evidence of a "Fed information effect": hawkish surprises raise
#' private-sector growth forecasts. Bauer and Swanson (2023, AER 113(3))
#' argue the pattern is better explained by the Fed and professional
#' forecasters reacting to the same pre-meeting public data ("Fed
#' response to news"). Users estimating causal macro effects of policy
#' should consider [bauer_swanson] (MPS_ORTH) or
#' [miranda_agrippino_ricco] as alternatives that address this bias.
#'
#' **Unscheduled meetings.** Inter-meeting cuts (notably 22 January 2008
#' and 8 October 2008) are included in the series and drive a large
#' share of sample variance.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. Policy news shock, scaled to one-year
#'     Treasury-yield equivalents (percentage points).}
#'   \item{series}{`character`. Series identifier `"nakamura_steinsson"`.}
#' }
#'
#' @source Nakamura, E., & Steinsson, J. (2018). "High-Frequency
#'   Identification of Monetary Non-Neutrality: The Information Effect."
#'   *Quarterly Journal of Economics* 133(3): 1283-1330.
#'   \doi{10.1093/qje/qjy004}. Replication archive on Harvard Dataverse:
#'   \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN}
#'   (CC0 1.0 Universal public domain dedication).
"nakamura_steinsson"

#' Bauer-Swanson orthogonalised monetary policy surprise
#'
#' The monthly orthogonalised monetary policy surprise series (MPS_ORTH)
#' from Bauer and Swanson (2023), with the raw MPS alongside. The
#' orthogonalised series removes predictability from public economic
#' information available before each FOMC meeting, isolating a genuinely
#' exogenous monetary-policy innovation.
#'
#' @details
#' **Orthogonalisation.** MPS_ORTH is the OLS residual from regressing
#' the raw MPS on six pre-announcement predictors: surprise in the most
#' recent nonfarm payrolls release, trailing 12-month employment growth,
#' log S&P 500 change over the prior three months, change in the 10-year
#' minus 2-year Treasury slope over the same window, log commodity-price-
#' index change, and Bauer-Chernov option-implied 10-year Treasury
#' skewness. See Bauer and Swanson (2023) Appendix Table A.1 for exact
#' predictor definitions and data sources.
#'
#' **Relation to [nakamura_steinsson].** Both series use a first
#' principal component of tight-window futures surprises. MPS_ORTH
#' additionally removes predictability from public data, which Bauer-
#' Swanson argue isolates the policy shock from the "Fed response to
#' news" that NS attribute to a Fed information effect.
#'
#' **Critique.** Hoesch, Rossi, and Sekhposyan (2023) show alternative
#' orthogonalisation choices yield different residuals. If the Fed has
#' any informational advantage, the orthogonalisation throws it away by
#' construction.
#'
#' **Vintage.** Bundled from the FRBSF-maintained update covering through
#' December 2023. For a frozen vintage, download directly from the source
#' URL in [mp_source()].
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. Orthogonalised MPS, percentage points.}
#'   \item{mps_raw}{`numeric`. Raw high-frequency MPS summed within the
#'     month, percentage points.}
#'   \item{series}{`character`. Series identifier `"bauer_swanson"`.}
#' }
#'
#' @source Bauer, M. D., & Swanson, E. T. (2023). "A Reassessment of
#'   Monetary Policy Surprises and High-Frequency Identification."
#'   *NBER Macroeconomics Annual* 37: 87-155. \doi{10.1086/723574}.
#'   Data: \url{https://www.frbsf.org/research-and-insights/data-and-indicators/monetary-policy-surprises/}.
"bauer_swanson"

#' GSS target factor (Swanson extended)
#'
#' The Federal Funds Rate factor from Swanson's (2021) three-factor
#' decomposition of high-frequency FOMC surprises, the direct extension
#' of the original "target" factor in Gurkaynak, Sack, and Swanson (2005).
#' Event-level factor values are summed within calendar months; months
#' with no scheduled FOMC meeting are coded as zero.
#'
#' @details
#' **Identification.** Swanson (2021) computes the first three principal
#' components of high-frequency futures surprises, then rotates them by
#' (i) zero loading of factor 3 on the current-month fed-funds-rate
#' surprise, (ii) minimum sum of squared factor-3 values over the
#' pre-ZLB sample 1991-07 to 2008-12, and (iii) sign normalisation.
#' The target and path factors are therefore conditional on the
#' pre-ZLB window used to pin down factor 3. Extensions past the
#' bundled span must re-estimate the rotation, not simply append new
#' events.
#'
#' **Relation to GSS 2005.** Pre-2009 the target factor closely tracks
#' the original two-factor decomposition of Gurkaynak, Sack, and Swanson
#' (2005). Post-2009 it differs because unconventional policy
#' announcements are absorbed by a distinct LSAP factor (not bundled
#' in v0.1.0; see Swanson's website for the full three-factor panel).
#'
#' **Monthly aggregation.** Event-level factors are summed within
#' calendar months. Months with no scheduled FOMC meeting are coded 0.
#' Users who want to distinguish "no news" from "news = 0" should recode
#' no-meeting months as `NA` before estimation (Bu, Rogers, and Wu 2021,
#' *Journal of Monetary Economics* 118).
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. GSS target factor, percentage points.}
#'   \item{series}{`character`. Series identifier `"gss_target"`.}
#' }
#'
#' @source Swanson, E. T. (2021). "Measuring the Effects of Federal
#'   Reserve Forward Guidance and Asset Purchases on Financial Markets."
#'   *Journal of Monetary Economics* 118: 32-53.
#'   \doi{10.1016/j.jmoneco.2020.09.003}. Data:
#'   \url{https://sites.socsci.uci.edu/~swanson2/}. Original two-factor
#'   decomposition: Gurkaynak, R. S., Sack, B., and Swanson, E. T.
#'   (2005), *International Journal of Central Banking* 1(1): 55-93.
"gss_target"

#' GSS path factor (Swanson extended)
#'
#' The Forward Guidance factor from Swanson's (2021) three-factor
#' decomposition of high-frequency FOMC surprises, the direct extension
#' of the original "path" factor in Gurkaynak, Sack, and Swanson (2005).
#' Event-level factor values are summed within calendar months; months
#' with no scheduled FOMC meeting are coded as zero.
#'
#' @details
#' See [gss_target] for identification, rotation sensitivity, and
#' aggregation details; the same caveats apply to both factors since
#' they come from a joint rotation.
#'
#' **Regime coverage.** The path factor picks up forward-guidance
#' surprises and is the most informative Swanson factor during the
#' zero-lower-bound period (2009 to 2015). Its variance rises sharply in
#' that window relative to the pre-ZLB sample, consistent with forward
#' guidance becoming the dominant policy tool.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. GSS path factor, percentage points.}
#'   \item{series}{`character`. Series identifier `"gss_path"`.}
#' }
#'
#' @source Swanson, E. T. (2021). "Measuring the Effects of Federal
#'   Reserve Forward Guidance and Asset Purchases on Financial Markets."
#'   *Journal of Monetary Economics* 118: 32-53.
#'   \doi{10.1016/j.jmoneco.2020.09.003}. Data:
#'   \url{https://sites.socsci.uci.edu/~swanson2/}.
"gss_path"

#' Jarocinski-Karadi pure monetary policy shock
#'
#' The "pure" monetary policy shock from Jarocinski and Karadi (2020),
#' identified via sign restrictions on the joint response of short-term
#' interest rates and stock prices around FOMC announcements. The median
#' decomposition allows the MP and information shocks to co-occur.
#' Monthly US series from the authors' maintained update.
#'
#' @details
#' **Identification.** Two high-frequency surprises enter: the 3-month
#' fed-funds futures and the S&P 500, both in 30-minute windows around
#' FOMC announcements. A 2-shock SVAR is identified by sign restrictions:
#' a positive MP shock raises rates and lowers stocks (negative
#' co-movement); a positive CB-information shock raises both (positive
#' co-movement).
#'
#' **Median vs poor-man's decomposition.** The "poor-man's" variant sorts
#' events by sign pattern and assigns each surprise wholly to one shock.
#' The median variant solves the set-identified problem and picks the
#' rotation whose impulse responses lie at the median of admissible
#' rotations; both shocks can co-occur at every event. `mpshock` uses
#' the median version (`MP_median`, `CBI_median`). Results are
#' set-identified, not point-identified: users should report robustness
#' across rotations.
#'
#' **Critical follow-up.** Acosta (2023, "Perceived Causes of Monetary
#' Policy Surprises") argues that the rate-stock sign pattern is a weak
#' discriminator between policy and information shocks because the two
#' are typically negatively correlated at high frequency regardless of
#' shock type. Bauer and Swanson (2023) argue the information shock
#' reflects omitted pre-announcement data rather than genuine Fed private
#' information. Users estimating information-effect IRFs should report
#' robustness to these critiques.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. Pure MP shock (MP_median), percentage
#'     points.}
#'   \item{series}{`character`. Series identifier
#'     `"jarocinski_karadi_mp"`.}
#' }
#'
#' @source Jarocinski, M., & Karadi, P. (2020). "Deconstructing Monetary
#'   Policy Surprises: The Role of Information Shocks." *American
#'   Economic Journal: Macroeconomics* 12(2): 1-43.
#'   \doi{10.1257/mac.20180090}. Updated data:
#'   \url{https://github.com/marekjarocinski/jkshocks_update_fed_202401}.
"jarocinski_karadi_mp"

#' Jarocinski-Karadi central bank information shock
#'
#' The "central bank information" shock from Jarocinski and Karadi
#' (2020), identified alongside the pure MP shock by sign restrictions
#' on the joint rate-stock response. The information shock moves short
#' rates and stock prices in the same direction, interpreted as the
#' central bank revealing private information about the economy.
#' Monthly US series from the authors' maintained update.
#'
#' @details
#' See [jarocinski_karadi_mp] for the full identification scheme and
#' caveats. The information shock is the companion component: if markets
#' interpret a hawkish rate surprise as a sign the Fed has seen positive
#' economic news, stocks rise rather than fall.
#'
#' **Controversy.** Bauer-Swanson (2023) and Acosta (2023) argue the
#' information shock is largely artefactual: an omitted-variables problem
#' (Fed and markets reacting to the same pre-meeting public data) plus a
#' weak sign-restriction identifier. Interpret with caution; if the
#' information-effect literature is central to your result, read both
#' critiques before citing.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. CB information shock (CBI_median),
#'     percentage points.}
#'   \item{series}{`character`. Series identifier
#'     `"jarocinski_karadi_cbi"`.}
#' }
#'
#' @source Jarocinski, M., & Karadi, P. (2020). "Deconstructing Monetary
#'   Policy Surprises: The Role of Information Shocks." *American
#'   Economic Journal: Macroeconomics* 12(2): 1-43.
#'   \doi{10.1257/mac.20180090}. Updated data:
#'   \url{https://github.com/marekjarocinski/jkshocks_update_fed_202401}.
"jarocinski_karadi_cbi"

#' Miranda-Agrippino-Ricco informationally-robust MP shock
#'
#' The informationally-robust monetary policy shock from Miranda-
#' Agrippino and Ricco (2021), constructed as the component of FF4
#' (fourth Eurodollar futures) high-frequency surprises orthogonal to
#' the Fed's Greenbook information set. Isolates exogenous policy moves
#' from shifts in the central bank's private information about the
#' economy. Monthly US series from the Degasperi and Ricco maintained
#' extension.
#'
#' @details
#' **Construction.** The raw FF4 surprise (3-month-ahead fed-funds
#' futures) is projected on the Fed's Greenbook / Tealbook forecast
#' revisions for GDP, unemployment, and inflation at horizons of zero to
#' four quarters (Miranda-Agrippino and Ricco 2021, Section III). The
#' residual is the informationally-robust monetary policy shock.
#'
#' **Extension past 2013.** The published paper covers 1991 to 2009; the
#' Degasperi-Ricco maintained update extends to June 2019. Because the
#' Fed's Tealbook is subject to a five-year release embargo, post-2013
#' observations use real-time SPF and Greenbook-equivalent series
#' instead. These are not strictly on the same information basis as the
#' published 1991 to 2009 series.
#'
#' **Ramey critique.** Ramey (2018, discussion of Miranda-Agrippino-Ricco
#' at the NBER Summer Institute) notes that orthogonalisation is with
#' respect to the Fed's information set, not the market's. Any news
#' markets infer from the announcement beyond the Tealbook remains in
#' the residual. Weak-instrument F-statistics drop materially after 2007.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. Informationally-robust MP shock, percentage
#'     points.}
#'   \item{info}{`numeric`. Companion information component, percentage
#'     points.}
#'   \item{series}{`character`. Series identifier
#'     `"miranda_agrippino_ricco"`.}
#' }
#'
#' @source Miranda-Agrippino, S., & Ricco, G. (2021). "The Transmission
#'   of Monetary Policy Shocks." *American Economic Journal:
#'   Macroeconomics* 13(3): 74-107. \doi{10.1257/mac.20180124}. Updated
#'   data:
#'   \url{https://github.com/riccardo-degasperi/info-policy-surprises}.
"miranda_agrippino_ricco"

#' Wu-Xia shadow federal funds rate
#'
#' The monthly Wu-Xia shadow federal funds rate from Wu and Xia (2016),
#' maintained and published by the Federal Reserve Bank of Atlanta. The
#' shadow rate is the authors' estimate of what the federal funds rate
#' would have been during zero-lower-bound episodes (2008-12 to 2015-12
#' and 2020-03 to 2022-02) had policy rates been allowed to go negative.
#' The companion effective federal funds rate (`effr`) is included for
#' reference.
#'
#' @details
#' **Stance vs shock.** The shadow rate is a **stance measure**, not a
#' policy shock. The `shock` column is the first difference of
#' `shadow_rate` and is provided for pipeline compatibility with other
#' series in the package. It conflates genuine policy news with Kalman-
#' filter revisions of the latent state. Users estimating shock IRFs
#' should prefer an event-study series ([nakamura_steinsson],
#' [bauer_swanson], [miranda_agrippino_ricco]) and reserve `wu_xia`
#' for characterising the zero-lower-bound policy stance.
#'
#' **Model sensitivity.** Krippner (2020, *Journal of Money, Credit and
#' Banking* 52(4)) documents that shadow-rate estimates are sensitive
#' to the choice of effective lower bound, the number of factors (two
#' versus three), and the set of yield maturities used in estimation.
#' Wu-Xia's three-factor shadow-rate term-structure model (SRTSM) and
#' Krippner's two-factor SSR can differ by 50 to 150 basis points at the
#' 2014 and 2021 troughs. Results that rely on Wu-Xia alone should be
#' replicated with at least one alternative shadow-rate series.
#'
#' **Vintage.** This bundled series is the Atlanta Fed monthly update
#' current as of the package build. Historical values are filtered
#' estimates and can change when new data arrives; users needing a
#' fixed vintage should download the archived Atlanta Fed file directly.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. First difference of shadow rate (percentage
#'     points per annum).}
#'   \item{shadow_rate}{`numeric`. Wu-Xia shadow federal funds rate at
#'     last business day of the month (percentage points per annum).}
#'   \item{effr}{`numeric`. Effective federal funds rate at last business
#'     day of the month (percentage points per annum).}
#'   \item{series}{`character`. Series identifier `"wu_xia"`.}
#' }
#'
#' @source Wu, J. C., & Xia, F. D. (2016). "Measuring the Macroeconomic
#'   Impact of Monetary Policy at the Zero Lower Bound." *Journal of
#'   Money, Credit and Banking* 48(2-3): 253-291.
#'   \doi{10.1111/jmcb.12300}. Data:
#'   \url{https://www.atlantafed.org/cqer/research/wu-xia-shadow-federal-funds-rate}.
#'   US Federal Reserve research output; not subject to copyright under
#'   17 U.S.C. s. 105.
"wu_xia"

#' UK Monetary Policy Event-Study Database (Braun-Miranda-Agrippino-Saha)
#'
#' The UK equivalent of the Gurkaynak-Sack-Swanson three-factor
#' decomposition: a principal-component rotation of high-frequency
#' surprises in OIS rates, gilt yields, short-sterling futures, and the
#' FTSE 100 around Bank of England MPC announcements and Monetary Policy
#' Report press conferences. Bundled at monthly frequency; months with no
#' MPC announcement are coded zero.
#'
#' @details
#' **Three factors.** The UK Monetary Policy Event-Study Database (UKMPD)
#' rotates three principal components into Target (current Bank Rate
#' surprise), Path (forward-guidance surprise), and QE (long-end
#' asset-purchase surprise). The package bundles `shock = Target`, with
#' `path` and `qe` as additional columns for users running multi-factor
#' local projections.
#'
#' **Maintenance.** UKMPD is the flagship UK shock database: live-
#' maintained by the authors and published through the Bank of England
#' Staff Working Paper series. The bundled version is a snapshot from
#' the package build; check the source URL for the latest vintage if
#' you need observations after the bundled end date.
#'
#' **Relation to older UK series.** UKMPD effectively supersedes the
#' Gerko-Rey (2017) UK surprises and the pre-MPR vintage of
#' [cesa_bianchi_uk]. Cesa-Bianchi-Thwaites-Vicondoa and Cloyne-Hurtgen
#' remain useful for pre-1997 coverage and for narrative comparison.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. Target factor (current Bank Rate surprise),
#'     percentage points.}
#'   \item{path}{`numeric`. Path factor (forward-guidance surprise),
#'     percentage points.}
#'   \item{qe}{`numeric`. QE factor (long-end asset-purchase surprise),
#'     percentage points.}
#'   \item{series}{`character`. Series identifier `"ukmpd"`.}
#' }
#'
#' @source Braun, R., Miranda-Agrippino, S., & Saha, T. (2025).
#'   "Measuring Monetary Policy in the UK: The UK Monetary Policy
#'   Event-Study Database." *Journal of Monetary Economics* 149.
#'   \doi{10.1016/j.jmoneco.2024.103645}. Data:
#'   \url{https://www.bankofengland.co.uk/working-paper/2023/measuring-monetary-policy-in-the-uk-ukmpd}.
"ukmpd"

#' Cesa-Bianchi-Thwaites-Vicondoa UK high-frequency shock
#'
#' High-frequency monetary policy surprise for the United Kingdom,
#' constructed from tight-window changes in the three-month sterling
#' interbank rate around Bank of England MPC announcements. Kuttner-style
#' identification adapted for the UK. Monthly frequency.
#'
#' @details
#' **Identification.** Surprises are extracted as the change in the
#' three-month sterling interbank rate in a 60-minute window around each
#' MPC announcement, isolating the unexpected component of the policy
#' decision. Event-level values are aggregated to monthly by summation;
#' months with no MPC meeting are coded zero.
#'
#' **Superseded.** For the same identification strategy with a richer
#' asset-price menu and ongoing maintenance, use [ukmpd]. The CTV series
#' remains useful as a historical reference and for comparisons with
#' pre-UKMPD empirical literature.
#'
#' **Vintage.** Static at the published version (1997-06 to 2015-01).
#' No extension maintained by the authors.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. UK HFI surprise, percentage points.}
#'   \item{series}{`character`. Series identifier `"cesa_bianchi_uk"`.}
#' }
#'
#' @source Cesa-Bianchi, A., Thwaites, G., & Vicondoa, A. (2020).
#'   "Monetary policy transmission in the United Kingdom: A high
#'   frequency identification approach." *European Economic Review*
#'   123: 103375. \doi{10.1016/j.euroecorev.2020.103375}. Data:
#'   \url{https://sites.google.com/site/ambropo/publications}.
"cesa_bianchi_uk"

#' Cloyne-Hurtgen UK narrative monetary policy shock
#'
#' Narrative Romer-Romer-style monetary policy shock for the United
#' Kingdom. Cash-rate changes are purged of their systematic response
#' to Bank of England internal forecasts, leaving a series of exogenous
#' policy innovations. Monthly frequency.
#'
#' @details
#' **Narrative identification.** Cloyne and Hurtgen (2016) read the
#' Bank of England *Inflation Report* forecasts and regress each Bank
#' Rate change on the Bank's own real-time projections for output,
#' unemployment, and inflation at horizons up to two years. The
#' residual is the "narrative" shock. The bundled series is the
#' extension carried forward by Cesa-Bianchi, Thwaites, and Vicondoa
#' using the same methodology; the original paper covers 1975 to 2007
#' but the bundled vintage is the CTV re-compiled version from 1997-06
#' onwards.
#'
#' **Comparison with HFI.** Narrative shocks are typically lower-
#' frequency than high-frequency event-window surprises and capture
#' broader policy reassessments. They can differ materially from
#' [cesa_bianchi_uk] and [ukmpd] even on common sample.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. UK narrative shock, percentage points.}
#'   \item{series}{`character`. Series identifier `"cloyne_hurtgen_uk"`.}
#' }
#'
#' @source Cloyne, J., & Hurtgen, P. (2016). "The Macroeconomic Effects
#'   of Monetary Policy: A New Measure for the United Kingdom."
#'   *American Economic Journal: Macroeconomics* 8(4): 75-102.
#'   \doi{10.1257/mac.20150093}. Replication data on openICPSR
#'   project 114114; bundled vintage is the Cesa-Bianchi-Thwaites-
#'   Vicondoa (2020) re-compilation available at
#'   \url{https://sites.google.com/site/ambropo/publications}.
"cloyne_hurtgen_uk"

#' Hambur-Haque Australian monetary policy shock
#'
#' High-frequency monetary policy surprise for Australia, decomposed
#' into three components (action, path, and term premium) by a principal-
#' component rotation of changes in overnight-indexed swap and Australian
#' Government Securities yields around RBA cash-rate decisions. Monthly
#' frequency; months with no RBA board meeting are coded zero.
#'
#' @details
#' **Identification.** Three PC components are rotated to isolate
#' (i) `action`, the current-meeting cash-rate surprise;
#' (ii) `path`, the forward-guidance surprise in expected short rates;
#' (iii) `term_premium`, the residual long-end move attributable to
#' duration / term-premium effects. `shock` is set to `action` for
#' pipeline compatibility; users running multi-factor IRFs should use
#' the individual component columns.
#'
#' **Coverage.** The bundled series spans April 2001 to December 2019,
#' matching the published paper. The RBA has not released a maintained
#' extension covering the COVID-era LSAP period.
#'
#' **Licence.** Published as an RBA Research Discussion Paper under
#' Commonwealth of Australia Creative Commons Attribution 4.0
#' International licence.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. Action factor (current cash-rate surprise),
#'     percentage points.}
#'   \item{action}{`numeric`. Current-meeting cash-rate surprise,
#'     percentage points.}
#'   \item{path}{`numeric`. Forward-guidance surprise, percentage points.}
#'   \item{term_premium}{`numeric`. Long-end term-premium surprise,
#'     percentage points.}
#'   \item{series}{`character`. Series identifier `"hambur_haque_au"`.}
#' }
#'
#' @source Hambur, J., & Haque, Q. (2023). "Monetary Policy Transmission,
#'   Real Interest Rates and Credit Spreads: Evidence from Australia."
#'   *Economic Record* (2024). \doi{10.1111/1475-4932.12786}. Data:
#'   Reserve Bank of Australia Research Discussion Paper 2023-04,
#'   \url{https://www.rba.gov.au/publications/rdp/2023/2023-04/}.
#'   CC BY 4.0.
"hambur_haque_au"

#' Beckers Australian narrative monetary policy shock
#'
#' Narrative Romer-Romer-style monetary policy shock for Australia.
#' RBA cash-rate changes are purged of their systematic response to the
#' Bank's internal forecasts (Bishop-Tulip 2017 methodology) and further
#' augmented with credit-spread information to separate genuine policy
#' innovations from responses to financial conditions. Quarterly
#' frequency. The headline bundled `shock` is Beckers's preferred
#' credit-spread-augmented series ("BT-CS"); the pre-augmentation
#' Bishop-Tulip series (`bt`) is included alongside for comparison.
#'
#' @details
#' **Construction.** The BT-CS series regresses cash-rate changes on
#' RBA internal forecasts (GDP, unemployment, CPI) plus measures of
#' domestic credit spreads, at quarterly frequency. The residual is
#' the identified policy shock.
#'
#' **Frequency note.** This is the only quarterly-frequency series
#' currently bundled in `mpshock`. [mp_to_quarterly()] is unnecessary;
#' pass `beckers_au` directly into quarterly VARs or LPs.
#'
#' **Licence.** RBA research output under Creative Commons Attribution
#' 4.0 International.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation quarter.}
#'   \item{shock}{`numeric`. BT-CS shock (preferred), percentage points.}
#'   \item{bt}{`numeric`. Bishop-Tulip pre-augmentation shock,
#'     percentage points.}
#'   \item{rate_chg}{`numeric`. Raw quarterly cash-rate change,
#'     percentage points.}
#'   \item{series}{`character`. Series identifier `"beckers_au"`.}
#' }
#'
#' @source Beckers, B. (2020). "Credit Spreads, Monetary Policy and the
#'   Price Puzzle in Australia." Reserve Bank of Australia Research
#'   Discussion Paper 2020-01.
#'   \url{https://www.rba.gov.au/publications/rdp/2020/2020-01/}.
#'   CC BY 4.0. Bishop-Tulip methodology: Bishop, J., & Tulip, P.
#'   (2017). "Anticipatory Monetary Policy and the Price Puzzle." RBA
#'   Research Discussion Paper 2017-02.
"beckers_au"
