#' Align a shock series to a target data frame by date
#'
#' Left-joins a shock series onto a target data frame by its date column.
#' Non-matching target rows receive `NA` in the shock column. Use this to
#' line a shock series up with a macro panel before running impulse
#' responses or local projections.
#'
#' @param shock An `mp_shock` object from [mp_shock()].
#' @param target A data frame containing a date column.
#' @param by Character(1). The name of the date column in `target`.
#'   Defaults to `"date"`.
#' @param fill_zero Logical(1). If `TRUE`, non-matching target rows get
#'   `0` in the shock column instead of `NA`. Useful when the target is a
#'   complete monthly panel and missing shocks should be treated as
#'   zero-surprise months. Defaults to `FALSE`.
#'
#' @return A data frame with the same rows as `target` plus a `shock`
#'   column (and any other numeric columns from the shock series, prefixed
#'   with the series name).
#'
#' @examples
#' panel <- data.frame(
#'   date = seq(as.Date("2010-01-01"), as.Date("2010-06-01"), by = "month"),
#'   gdp_growth = rnorm(6)
#' )
#' aligned <- mp_align(mp_shock("nakamura_steinsson"), panel)
#' head(aligned)
#'
#' @export
mp_align <- function(shock, target, by = "date", fill_zero = FALSE) {
  if (!inherits(shock, "mp_shock")) {
    cli::cli_abort("{.arg shock} must be an {.cls mp_shock} object from {.fn mp_shock}.")
  }
  if (!is.data.frame(target)) {
    cli::cli_abort("{.arg target} must be a data frame.")
  }
  if (!by %in% names(target)) {
    cli::cli_abort("Column {.val {by}} not found in {.arg target}.")
  }
  target[[by]] <- validate_date(target[[by]], by)

  shock_df <- as.data.frame(shock)
  shock_df[[by]] <- shock_df$date
  if (by != "date") shock_df$date <- NULL
  shock_df$series <- NULL

  out <- merge(target, shock_df, by = by, all.x = TRUE, sort = FALSE)
  out <- out[order(out[[by]]), , drop = FALSE]
  row.names(out) <- NULL

  if (isTRUE(fill_zero)) {
    new_cols <- setdiff(names(out), names(target))
    for (col in new_cols) {
      if (is.numeric(out[[col]])) {
        out[[col]][is.na(out[[col]])] <- 0
      }
    }
  }

  out
}
