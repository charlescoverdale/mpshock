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
