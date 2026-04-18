#' Aggregate a monthly shock series to quarterly frequency
#'
#' Converts a monthly `mp_shock` object to quarterly observations using one
#' of three aggregation methods.
#'
#' @param shock An `mp_shock` object from [mp_shock()] at monthly frequency.
#' @param method Character(1). One of `"sum"` (the default, usual choice
#'   for additive shocks), `"mean"` (arithmetic mean of months in the
#'   quarter), or `"end"` (last month's value, useful for stock-like
#'   measures such as shadow rates).
#'
#' @return A data frame with one row per quarter, containing a `date`
#'   column set to the first day of the quarter, the aggregated `shock`
#'   column, and the series identifier. Class `c("mp_shock",
#'   "data.frame")`.
#'
#' @examples
#' ns_q <- mp_to_quarterly(mp_shock("nakamura_steinsson"), method = "sum")
#' head(ns_q)
#'
#' @export
mp_to_quarterly <- function(shock, method = c("sum", "mean", "end")) {
  if (!inherits(shock, "mp_shock")) {
    cli::cli_abort("{.arg shock} must be an {.cls mp_shock} object.")
  }
  method <- match.arg(method)

  numeric_cols <- setdiff(
    names(shock)[vapply(shock, is.numeric, logical(1))],
    "date"
  )
  if (length(numeric_cols) == 0L) {
    cli::cli_abort("No numeric columns found to aggregate.")
  }

  quarter_start <- as.Date(
    paste0(
      format(shock$date, "%Y"), "-",
      sprintf("%02d", ((as.integer(format(shock$date, "%m")) - 1L) %/% 3L) * 3L + 1L),
      "-01"
    )
  )

  out <- stats::aggregate(
    shock[, numeric_cols, drop = FALSE],
    by = list(date = quarter_start),
    FUN = switch(method,
      sum  = function(x) sum(x, na.rm = TRUE),
      mean = function(x) mean(x, na.rm = TRUE),
      end  = function(x) if (length(x) == 0L) NA_real_ else x[length(x)]
    )
  )
  out$series <- attr(shock, "series") %||% shock$series[1L]
  out <- out[, c("date", numeric_cols, "series"), drop = FALSE]
  row.names(out) <- NULL

  class(out) <- c("mp_shock", "data.frame")
  attr(out, "series") <- attr(shock, "series")
  attr(out, "frequency") <- "quarterly"
  out
}
