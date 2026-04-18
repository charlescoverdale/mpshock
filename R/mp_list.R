#' List available monetary policy shock series
#'
#' Returns a metadata table of every shock or stance series bundled in the
#' package.
#'
#' @return A data frame with one row per series and columns:
#' * `series`: identifier used with [mp_shock()].
#' * `author`: short author string, e.g. "Nakamura and Steinsson (2018)".
#' * `country`: ISO country code or "EA" for Euro area.
#' * `frequency`: `"monthly"`, `"quarterly"`, or `"event"`.
#' * `type`: `"shock"` for identified monetary policy shocks,
#'   `"shadow_rate"` for shadow-rate stance measures, `"surprise"` for
#'   high-frequency event-window surprises.
#' * `start`, `end`: coverage span as `Date` (first and last bundled
#'   observation).
#' * `n`: number of non-missing shock observations.
#' * `doi`: DOI of the source paper.
#' * `source_url`: canonical URL for the published series.
#' * `description`: short prose description.
#'
#' @examples
#' mp_list()
#'
#' @export
mp_list <- function() {
  meta <- .mp_meta_static()

  spans <- lapply(meta$series, function(s) {
    dat <- .mp_load_raw(s)
    list(
      start = min(dat$date, na.rm = TRUE),
      end   = max(dat$date, na.rm = TRUE),
      n     = sum(!is.na(dat$shock))
    )
  })
  meta$start <- do.call("c", lapply(spans, `[[`, "start"))
  meta$end   <- do.call("c", lapply(spans, `[[`, "end"))
  meta$n     <- vapply(spans, `[[`, integer(1), "n")

  meta[, c("series", "author", "country", "frequency", "type",
           "start", "end", "n", "doi", "source_url", "description")]
}
