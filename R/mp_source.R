#' Citation and provenance for a shock series
#'
#' Returns a single-row data frame with the author, DOI, source URL, and
#' short description for the named series. Also prints the citation to the
#' console.
#'
#' @param series Character(1). Name of the series. See [mp_list()] for
#'   available series.
#'
#' @return Invisibly, a one-row data frame with columns `series`, `author`,
#'   `doi`, `source_url`, `description`.
#'
#' @examples
#' mp_source("nakamura_steinsson")
#'
#' @export
mp_source <- function(series) {
  validate_series(series)
  meta <- .mp_meta_static()
  row <- meta[meta$series == series, c("series", "author", "doi",
                                       "source_url", "description"),
              drop = FALSE]
  row.names(row) <- NULL

  cli::cli_inform(c(
    "{.strong {row$series}}",
    " " = "{row$author}",
    " " = "DOI: {row$doi}",
    " " = "URL: {row$source_url}",
    " " = "{row$description}"
  ))

  invisible(row)
}
