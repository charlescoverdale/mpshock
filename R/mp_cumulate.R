#' Cumulate a shock series
#'
#' Computes running sums of a shock series. With `window = NULL`, returns
#' the full cumulative sum. With a finite `window`, returns a rolling
#' window sum of the last `window` observations.
#'
#' @param shock An `mp_shock` object from [mp_shock()].
#' @param window Integer, the rolling window length in observations. If
#'   `NULL` (default), computes the full cumulative sum.
#'
#' @return A data frame with the same rows as `shock` and a new column
#'   `shock_cum` (full cumulative) or `shock_roll` (rolling window). Other
#'   columns are preserved.
#'
#' @examples
#' cum <- mp_cumulate(mp_shock("nakamura_steinsson"))
#' head(cum)
#'
#' roll <- mp_cumulate(mp_shock("nakamura_steinsson"), window = 12)
#' head(roll, 15)
#'
#' @export
mp_cumulate <- function(shock, window = NULL) {
  if (!inherits(shock, "mp_shock")) {
    cli::cli_abort("{.arg shock} must be an {.cls mp_shock} object.")
  }
  if (!"shock" %in% names(shock)) {
    cli::cli_abort("{.arg shock} must contain a column named {.val shock}.")
  }

  x <- shock$shock
  x[is.na(x)] <- 0

  if (is.null(window)) {
    shock$shock_cum <- cumsum(x)
  } else {
    if (!is.numeric(window) || length(window) != 1L || window < 1L ||
        window != round(window)) {
      cli::cli_abort("{.arg window} must be a single positive integer.")
    }
    roll <- numeric(length(x))
    for (i in seq_along(x)) {
      lo <- max(1L, i - window + 1L)
      roll[i] <- sum(x[lo:i])
    }
    shock$shock_roll <- roll
  }

  shock
}
