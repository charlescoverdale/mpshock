# URL and DOI resolution tests.
#
# These are skipped on CRAN (network access not permitted during check)
# and when offline, but run locally as part of `devtools::test()`. They
# guard against a class of bug that silent-fails in regular testing:
# metadata DOIs or source URLs that reference the wrong paper or resource.
# The CrossRef API is the authoritative DOI registry; doi.org redirects
# via publishers which often block bot traffic (403s), so CrossRef is
# preferred for verification.

test_that("every DOI in mp_list() resolves via CrossRef", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("curl")

  dois <- mp_list()$doi
  dois <- dois[nzchar(dois)]

  ua <- "mpshock-test (https://github.com/charlescoverdale/mpshock)"
  for (doi in dois) {
    url <- paste0("https://api.crossref.org/works/", doi)
    # Retry once on transient rate-limit responses (429) or transport
    # errors; DOIs are static so a real failure will fail both attempts.
    resp <- NULL
    for (attempt in seq_len(2L)) {
      resp <- tryCatch(
        curl::curl_fetch_memory(url,
          handle = curl::new_handle(useragent = ua)),
        error = function(e) list(status_code = 0L)
      )
      if (isTRUE(resp$status_code == 200L)) break
      Sys.sleep(0.5)
    }
    expect_equal(resp$status_code, 200L,
                 info = paste("DOI does not resolve:", doi))
    Sys.sleep(0.1)  # polite pacing for the CrossRef API
  }
})

test_that("every source_url in mp_list() returns an OK-ish HTTP status", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("curl")

  urls <- mp_list()$source_url
  ua <- "Mozilla/5.0 (compatible; mpshock-test)"
  for (url in urls) {
    resp <- tryCatch(
      curl::curl_fetch_memory(url,
        handle = curl::new_handle(useragent = ua, nobody = TRUE)),
      error = function(e) list(status_code = 0L)
    )
    # Accept 2xx, 3xx, and 401/403 (openICPSR and similar auth-walled
    # pages are valid; they just require login to view). 404 is the
    # real failure mode we want to catch.
    ok <- (resp$status_code >= 200L && resp$status_code < 400L) ||
      resp$status_code %in% c(401L, 403L)
    expect_true(ok,
                info = paste("URL failed with",
                             resp$status_code, ":", url))
  }
})
