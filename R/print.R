#' Print an mp_shock object
#'
#' Prints a short provenance header followed by the first rows of the
#' shock series.
#'
#' @param x An `mp_shock` object.
#' @param n Integer, number of rows to print. Default 10.
#' @param ... Ignored.
#'
#' @return `x`, invisibly.
#'
#' @examples
#' print(mp_shock("nakamura_steinsson"))
#'
#' @export
print.mp_shock <- function(x, n = 10L, ...) {
  series <- attr(x, "series") %||% if ("series" %in% names(x)) x$series[1L] else "(unknown)"
  freq <- attr(x, "frequency") %||% "monthly"
  n_obs <- nrow(x)
  date_range <- if (n_obs > 0L) {
    paste0(format(min(x$date, na.rm = TRUE)), " to ", format(max(x$date, na.rm = TRUE)))
  } else {
    "(empty)"
  }

  cli::cli_inform(c(
    "{.strong <mp_shock>} {series} [{freq}, {n_obs} obs, {date_range}]"
  ))

  df <- as.data.frame(x)
  df$series <- NULL
  head_n <- min(n, n_obs)
  if (head_n > 0L) {
    print(utils::head(df, head_n), row.names = FALSE)
  }
  if (n_obs > head_n) {
    cli::cli_inform("... {n_obs - head_n} more row{?s}. Call {.code mp_source({.val {series}})} for citation.")
  }
  invisible(x)
}

#' @export
format.mp_shock <- function(x, ...) {
  series <- attr(x, "series") %||% "mp_shock"
  sprintf("<mp_shock: %s, %d obs>", series, nrow(x))
}
