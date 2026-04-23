`%||%` <- function(a, b) if (is.null(a)) b else a

# Static metadata table. Single source of truth for available series names
# and their published attribution. Spans and observation counts are computed
# on demand by mp_list() by loading the actual bundled datasets.
.mp_meta_static <- function() {
  data.frame(
    series = c(
      # US
      "nakamura_steinsson",
      "bauer_swanson",
      "gss_target",
      "gss_path",
      "jarocinski_karadi_mp",
      "jarocinski_karadi_cbi",
      "miranda_agrippino_ricco",
      "wu_xia",
      # UK
      "ukmpd",
      "cesa_bianchi_uk",
      "cloyne_hurtgen_uk",
      # AU
      "hambur_haque_au",
      "beckers_au"
    ),
    author = c(
      "Nakamura and Steinsson (2018)",
      "Bauer and Swanson (2023)",
      "Gurkaynak, Sack, Swanson (2005) / Swanson (2021)",
      "Gurkaynak, Sack, Swanson (2005) / Swanson (2021)",
      "Jarocinski and Karadi (2020)",
      "Jarocinski and Karadi (2020)",
      "Miranda-Agrippino and Ricco (2021)",
      "Wu and Xia (2016)",
      "Braun, Miranda-Agrippino, Saha (2025)",
      "Cesa-Bianchi, Thwaites, Vicondoa (2020)",
      "Cloyne and Hurtgen (2016)",
      "Hambur and Haque (2023)",
      "Beckers (2020)"
    ),
    country = c(
      "US", "US", "US", "US", "US", "US", "US", "US",
      "UK", "UK", "UK",
      "AU", "AU"
    ),
    frequency = c(
      rep("monthly", 12L),
      "quarterly"
    ),
    type = c(
      "shock", "shock", "shock", "shock",
      "shock", "information", "shock", "shadow_rate",
      "shock", "shock", "narrative",
      "shock", "narrative"
    ),
    doi = c(
      "10.1093/qje/qjy004",
      "10.1086/723574",
      "10.1016/j.jmoneco.2020.09.003",
      "10.1016/j.jmoneco.2020.09.003",
      "10.1257/mac.20180090",
      "10.1257/mac.20180090",
      "10.1257/mac.20180124",
      "10.1111/jmcb.12300",
      "10.1016/j.jmoneco.2024.103645",
      "10.1016/j.euroecorev.2020.103375",
      "10.1257/mac.20150093",
      "10.1111/1475-4932.12786",
      ""
    ),
    source_url = c(
      "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN",
      "https://www.frbsf.org/research-and-insights/data-and-indicators/monetary-policy-surprises/",
      "https://sites.socsci.uci.edu/~swanson2/",
      "https://sites.socsci.uci.edu/~swanson2/",
      "https://github.com/marekjarocinski/jkshocks_update_fed_202401",
      "https://github.com/marekjarocinski/jkshocks_update_fed_202401",
      "https://github.com/riccardo-degasperi/info-policy-surprises",
      "https://www.atlantafed.org/cqer/research/wu-xia-shadow-federal-funds-rate",
      "https://www.bankofengland.co.uk/working-paper/2023/measuring-monetary-policy-in-the-uk-ukmpd",
      "https://sites.google.com/site/ambropo/publications",
      "https://www.openicpsr.org/openicpsr/project/114114/version/V1/view",
      "https://www.rba.gov.au/publications/rdp/2023/2023-04/",
      "https://www.rba.gov.au/publications/rdp/2020/2020-01/"
    ),
    description = c(
      "Policy news shock: first principal component of five interest-rate futures surprises in a 30-minute window around FOMC announcements, aggregated to monthly.",
      "Orthogonalised monetary policy surprise (MPS_ORTH): high-frequency FOMC-event surprise purged of predictability from public information.",
      "Federal Funds Rate factor (extended): the Swanson (2021) three-factor decomposition analogue of the original GSS target factor, aggregated to monthly.",
      "Forward Guidance factor (extended): the Swanson (2021) three-factor decomposition analogue of the original GSS path factor, aggregated to monthly.",
      "Pure monetary policy shock (median decomposition): high-frequency FOMC surprise identified by sign restrictions on the joint rate-stock response.",
      "Central bank information shock (median decomposition): the component of FOMC surprises co-moving rates and stocks in the same direction.",
      "Informationally-robust monetary policy shock: FF4 high-frequency surprise orthogonalised against the Fed's Greenbook information set.",
      "Shadow federal funds rate: the Wu-Xia estimate of what the fed funds rate would have been during zero-lower-bound episodes. Shock column is the first difference.",
      "UK Monetary Policy Event-Study Database (UKMPD): three-factor decomposition (Target, Path, QE) of high-frequency surprises around Bank of England MPC announcements. Live-maintained by the BoE.",
      "UK high-frequency monetary policy surprise: Kuttner-style tight-window surprise around Bank of England MPC announcements, aggregated to monthly.",
      "UK narrative monetary policy shock: Romer-Romer-style identification using Bank of England Inflation Report forecasts to purge the cash rate of systematic reactions.",
      "Australian monetary policy surprise: three-component decomposition (action, path, term premium) of OIS and AGS yield moves around RBA cash-rate decisions.",
      "Australian narrative monetary policy shock: cash-rate changes orthogonal to RBA internal forecasts, augmented with credit-spread information (Beckers's 'BT-CS' headline series), quarterly."
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
