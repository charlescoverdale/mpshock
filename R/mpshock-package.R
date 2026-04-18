#' mpshock: Monetary Policy Shock Series for Empirical Macroeconomics
#'
#' Provides a curated collection of monetary policy shock and stance series
#' from the empirical macroeconomics literature, bundled as tidy data
#' frames with provenance metadata. All data is bundled; no runtime
#' network access is required.
#'
#' @section Main functions:
#'
#' * [mp_shock()] loads a named series.
#' * [mp_list()] returns a metadata table of available series.
#' * [mp_source()] returns the citation and source URL for a series.
#' * [mp_align()] aligns a series to a target data frame by date.
#' * [mp_to_quarterly()] aggregates monthly series to quarterly.
#' * [mp_cumulate()] computes cumulative or rolling-window shock sums.
#'
#' @section Bundled datasets:
#'
#' * [nakamura_steinsson]: policy news shock, 2000-02 to 2014-03.
#' * [wu_xia]: shadow federal funds rate, 1960-01 to 2022-02.
#'
#' @keywords internal
"_PACKAGE"

#' @importFrom cli cli_abort cli_inform cli_warn
#' @importFrom stats aggregate
#' @importFrom utils data
NULL
