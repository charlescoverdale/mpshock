#' Load a monetary policy shock series
#'
#' Loads a named shock series bundled with the package as a tidy data frame
#' with class `mp_shock`. Optionally filters by date range.
#'
#' @param series Character(1). Name of the series. See [mp_list()] for
#'   available series.
#' @param start,end Optional `Date` or character (YYYY-MM-DD) filters on
#'   the returned series. If `NULL`, returns the full bundled span.
#'
#' @return A data frame with class `c("mp_shock", "data.frame")` and
#'   columns:
#' * `date`: `Date`, first day of the observation month.
#' * `shock`: `numeric`, the shock value in the units published by the
#'   source (see [mp_source()] and the per-series help files for units
#'   and scaling conventions).
#' * `series`: `character`, the series identifier.
#'
#' Some series carry additional columns. [bauer_swanson] returns
#' `mps_raw` alongside `shock` (the orthogonalised surprise);
#' [miranda_agrippino_ricco] returns `info`; [wu_xia] returns
#' `shadow_rate` and `effr`.
#'
#' @details
#' **Aggregation.** All event-study series ([nakamura_steinsson],
#' [bauer_swanson], [gss_target], [gss_path], [jarocinski_karadi_mp],
#' [jarocinski_karadi_cbi], [miranda_agrippino_ricco]) are bundled at
#' monthly frequency by summing FOMC-event-level surprises within each
#' calendar month. Months with no scheduled FOMC meeting are coded zero,
#' matching the convention in Gertler and Karadi (2015) and the authors'
#' own maintained releases.
#'
#' Bu, Rogers, and Wu (2021, *Journal of Monetary Economics* 118) argue
#' that no-meeting months should be coded `NA` rather than zero when
#' estimating proxy-SVAR or LP-IV models, to avoid downward-biased
#' variance in weak-instrument F-statistics. `mpshock` does not apply
#' this adjustment; recode after loading if needed.
#'
#' **Scaling.** Units differ across series. [nakamura_steinsson] is
#' rescaled to one-year nominal Treasury-yield equivalents;
#' [bauer_swanson] and most others are in raw percentage-point
#' surprises. See each series' help file.
#'
#' @seealso [mp_list()], [mp_source()], [mp_align()], [mp_to_quarterly()].
#'
#' @examples
#' ns <- mp_shock("nakamura_steinsson")
#' head(ns)
#'
#' # Filter to a specific window
#' ns_gfc <- mp_shock("nakamura_steinsson",
#'                    start = "2007-01-01", end = "2009-12-31")
#'
#' @export
mp_shock <- function(series, start = NULL, end = NULL) {
  validate_series(series)
  dat <- .mp_load_raw(series)

  if (!is.null(start)) {
    start <- validate_date(start, "start")
    dat <- dat[dat$date >= start, , drop = FALSE]
  }
  if (!is.null(end)) {
    end <- validate_date(end, "end")
    dat <- dat[dat$date <= end, , drop = FALSE]
  }
  row.names(dat) <- NULL

  class(dat) <- c("mp_shock", "data.frame")
  attr(dat, "series") <- series
  dat
}
