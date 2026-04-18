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
#' United States:
#' * [nakamura_steinsson]: policy news shock, 2000-02 to 2014-03.
#' * [bauer_swanson]: orthogonalised MP surprise, 1988-02 to 2023-12.
#' * [gss_target]: GSS target factor (Swanson extended), 1991-07 to 2015-10.
#' * [gss_path]: GSS path factor (Swanson extended), 1991-07 to 2015-10.
#' * [jarocinski_karadi_mp]: pure MP shock, 1990-02 to 2024-01.
#' * [jarocinski_karadi_cbi]: CB information shock, 1990-02 to 2024-01.
#' * [miranda_agrippino_ricco]: informationally-robust MP shock, 1991-01 to 2019-06.
#' * [wu_xia]: shadow federal funds rate, 1960-01 to 2022-02.
#'
#' United Kingdom:
#' * [ukmpd]: three-factor UK event-study database (Target / Path / QE),
#'   1997-06 to the latest BoE vintage.
#' * [cesa_bianchi_uk]: UK high-frequency surprise, 1997-06 to 2015-01.
#' * [cloyne_hurtgen_uk]: UK narrative shock, 1997-06 to 2009-02.
#'
#' Australia:
#' * [hambur_haque_au]: three-component RBA HFI shock (action / path /
#'   term premium), 2001-04 to 2019-12.
#' * [beckers_au]: RBA narrative shock (Bishop-Tulip + credit spreads),
#'   quarterly 1994-Q1 to 2018-Q4.
#'
#' @section Further reading:
#'
#' For general background on shock identification, see Ramey (2016),
#' "Macroeconomic Shocks and Their Propagation," *Handbook of
#' Macroeconomics* 2: 71-162. For a recent cross-series comparison of
#' the identification strategies bundled here, see Aeberhardt, Bruno,
#' and Fidora (2024), "Monetary Policy Shocks: Data or Methods?" *FEDS
#' Working Paper* 2024-011.
#'
#' @keywords internal
"_PACKAGE"

#' @importFrom cli cli_abort cli_inform cli_warn
#' @importFrom stats aggregate
#' @importFrom utils data
NULL
