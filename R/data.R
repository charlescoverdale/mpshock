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
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. Policy news shock, percentage points.}
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
#' information available before each FOMC meeting, isolating a
#' genuinely exogenous monetary-policy innovation.
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
#' @source Bauer, M. D., & Swanson, E. T. (2023). "An Alternative
#'   Explanation for the 'Fed Information Effect'." *American Economic
#'   Review* 113(3): 664-700. \doi{10.1257/aer.20200994}. Data:
#'   \url{https://www.frbsf.org/research-and-insights/data-and-indicators/monetary-policy-surprises/}.
"bauer_swanson"

#' GSS target factor (Swanson extended)
#'
#' The Federal Funds Rate factor from Swanson's (2021) three-factor
#' decomposition of high-frequency FOMC surprises, the direct extension
#' of the original "target" factor in Gurkaynak, Sack, and Swanson (2005).
#' Event-level factor values are summed within calendar months; months
#' with no scheduled FOMC meeting are coded as zero.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. GSS target factor, percentage points.}
#'   \item{series}{`character`. Series identifier `"gss_target"`.}
#' }
#'
#' @source Swanson, E. T. (2021). "Measuring the Effects of Federal Reserve
#'   Forward Guidance and Asset Purchases on Financial Markets." *Journal
#'   of Monetary Economics* 118: 32-53.
#'   \doi{10.1016/j.jmoneco.2020.09.003}. Data:
#'   \url{https://sites.socsci.uci.edu/~swanson2/}. Original two-factor
#'   decomposition: Gurkaynak, Sack, and Swanson (2005), *IJCB* 1(1):
#'   55-93.
"gss_target"

#' GSS path factor (Swanson extended)
#'
#' The Forward Guidance factor from Swanson's (2021) three-factor
#' decomposition of high-frequency FOMC surprises, the direct extension
#' of the original "path" factor in Gurkaynak, Sack, and Swanson (2005).
#' Event-level factor values are summed within calendar months; months
#' with no scheduled FOMC meeting are coded as zero.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{`Date`. First day of the observation month.}
#'   \item{shock}{`numeric`. GSS path factor, percentage points.}
#'   \item{series}{`character`. Series identifier `"gss_path"`.}
#' }
#'
#' @source Swanson, E. T. (2021). "Measuring the Effects of Federal Reserve
#'   Forward Guidance and Asset Purchases on Financial Markets." *Journal
#'   of Monetary Economics* 118: 32-53.
#'   \doi{10.1016/j.jmoneco.2020.09.003}. Data:
#'   \url{https://sites.socsci.uci.edu/~swanson2/}.
"gss_path"

#' Jarocinski-Karadi pure monetary policy shock
#'
#' The "pure" monetary policy shock from Jarocinski and Karadi (2020),
#' identified via sign restrictions on the joint response of short-term
#' interest rates and stock prices around FOMC announcements. The median
#' decomposition allows the MP and information shocks to co-occur. Monthly
#' US series from the authors' maintained update.
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
#' The "central bank information" shock from Jarocinski and Karadi (2020),
#' identified alongside the pure MP shock by sign restrictions. The
#' information shock moves short rates and stock prices in the same
#' direction, interpreted as the central bank revealing private
#' information about the economy. Monthly US series from the authors'
#' maintained update.
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
#' The informationally-robust monetary policy shock from Miranda-Agrippino
#' and Ricco (2021), constructed as the component of FF4 (fourth
#' Eurodollar futures) high-frequency surprises orthogonal to the Fed's
#' Greenbook information set. Isolates exogenous policy moves from shifts
#' in the central bank's private information about the economy. Monthly
#' US series from the Degasperi and Ricco maintained extension.
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
#'   data: \url{https://github.com/riccardo-degasperi/info-policy-surprises}.
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
#' The `shock` column is the first difference of `shadow_rate`, so that
#' `wu_xia` can be used alongside identified-shock series in the same
#' pipeline. Users who want the level can use `shadow_rate` directly.
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
