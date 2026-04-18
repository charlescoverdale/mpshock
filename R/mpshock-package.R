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
#' @section Bundled datasets (v0.1.0):
#'
#' * [nakamura_steinsson]: policy news shock, 2000-02 to 2014-03.
#' * [bauer_swanson]: orthogonalised MP surprise, 1988-02 to 2023-12.
#' * [gss_target]: GSS target factor (Swanson extended), 1991-07 to 2015-10.
#' * [gss_path]: GSS path factor (Swanson extended), 1991-07 to 2015-10.
#' * [jarocinski_karadi_mp]: pure MP shock, 1990-02 to 2024-01.
#' * [jarocinski_karadi_cbi]: CB information shock, 1990-02 to 2024-01.
#' * [miranda_agrippino_ricco]: informationally-robust MP shock, 1991-01 to 2019-06.
#' * [wu_xia]: shadow federal funds rate, 1960-01 to 2022-02.
#'
#' @keywords internal
"_PACKAGE"

#' @importFrom cli cli_abort cli_inform cli_warn
#' @importFrom stats aggregate
#' @importFrom utils data
NULL
