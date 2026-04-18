`%||%` <- function(a, b) if (is.null(a)) b else a

# Static metadata table. Single source of truth for available series names
# and their published attribution. Spans and observation counts are computed
# on demand by mp_list() by loading the actual bundled datasets.
.mp_meta_static <- function() {
  data.frame(
    series = c("nakamura_steinsson", "wu_xia"),
    author = c(
      "Nakamura and Steinsson (2018)",
      "Wu and Xia (2016)"
    ),
    country = c("US", "US"),
    frequency = c("monthly", "monthly"),
    type = c("shock", "shadow_rate"),
    doi = c(
      "10.1093/qje/qjy004",
      "10.1111/jmcb.12300"
    ),
    source_url = c(
      "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN",
      "https://www.atlantafed.org/cqer/research/wu-xia-shadow-federal-funds-rate"
    ),
    description = c(
      "Policy news shock: first principal component of five interest-rate futures surprises in a 30-minute window around FOMC announcements, aggregated to monthly.",
      "Shadow federal funds rate: authors' estimate of what the fed funds rate would have been during zero-lower-bound episodes had rates been allowed to go negative."
    ),
    stringsAsFactors = FALSE
  )
}

# Load a bundled dataset by name, bypassing validation. Used internally by
# mp_list() and mp_shock(). Returns the raw data frame as saved in data/.
.mp_load_raw <- function(series) {
  env <- new.env(parent = emptyenv())
  utils::data(list = series, package = "mpshock", envir = env)
  if (!exists(series, envir = env, inherits = FALSE)) {
    cli::cli_abort("Failed to load series {.val {series}} from package data.")
  }
  env[[series]]
}

validate_date <- function(x, arg = "date") {
  if (inherits(x, "Date")) return(invisible(x))
  parsed <- tryCatch(as.Date(x), error = function(e) NULL, warning = function(w) NULL)
  if (is.null(parsed) || anyNA(parsed)) {
    cli::cli_abort("{.arg {arg}} must be a Date or a character vector parseable as a date.")
  }
  parsed
}

validate_series <- function(series) {
  choices <- .mp_meta_static()$series
  if (length(series) != 1L || !is.character(series)) {
    cli::cli_abort("{.arg series} must be a single character string.")
  }
  if (!series %in% choices) {
    cli::cli_abort(c(
      "Unknown series {.val {series}}.",
      "i" = "Available series: {.val {choices}}."
    ))
  }
  invisible(series)
}
