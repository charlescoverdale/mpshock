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
#' * `date`: `Date`, first day of the observation month (or event date).
#' * `shock`: `numeric`, the shock value in the units published by the
#'   source (see `mp_source()`).
#' * `series`: `character`, the series identifier.
#'
#' Some series include additional factor columns (for example `target`,
#' `path`, and `term_premium` for Bauer-Swanson).
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
