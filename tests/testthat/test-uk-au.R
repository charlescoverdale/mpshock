# Tests for UK and Australian series added in v0.1.0.

test_that("UKMPD has target, path, and qe columns", {
  x <- mp_shock("ukmpd")
  expect_true(all(c("date", "shock", "path", "qe", "series") %in% names(x)))
  # Target, path, qe should not be identical series
  expect_false(isTRUE(all.equal(x$shock, x$path)))
  expect_false(isTRUE(all.equal(x$shock, x$qe)))
})

test_that("UKMPD starts in June 1997", {
  x <- mp_shock("ukmpd")
  expect_equal(as.character(min(x$date)), "1997-06-01")
})

test_that("UKMPD QE factor has nonzero variance during 2009-2016 QE era", {
  x <- mp_shock("ukmpd",
                start = "2009-03-01", end = "2016-12-31")
  expect_gt(sd(x$qe, na.rm = TRUE), 0)
})

test_that("Cesa-Bianchi UK covers the EER published window", {
  x <- mp_shock("cesa_bianchi_uk")
  expect_equal(as.character(min(x$date)), "1997-06-01")
  expect_equal(as.character(max(x$date)), "2015-01-01")
})

test_that("Cloyne-Hurtgen UK narrative series has fewer obs than CTV", {
  ctv <- mp_shock("cesa_bianchi_uk")
  ch  <- mp_shock("cloyne_hurtgen_uk")
  expect_lte(nrow(ch), nrow(ctv))
})

test_that("Hambur-Haque AU has action, path, and term_premium columns", {
  x <- mp_shock("hambur_haque_au")
  expect_true(all(c("date", "shock", "action", "path", "term_premium",
                    "series") %in% names(x)))
  # shock equals the action factor for pipeline compatibility
  expect_equal(x$shock, x$action)
})

test_that("Hambur-Haque AU spans April 2001 to December 2019", {
  x <- mp_shock("hambur_haque_au")
  expect_equal(as.character(min(x$date)), "2001-04-01")
  expect_equal(as.character(max(x$date)), "2019-12-01")
})

test_that("Beckers AU has bt and rate_chg columns", {
  x <- mp_shock("beckers_au")
  expect_true(all(c("date", "shock", "bt", "rate_chg", "series")
                  %in% names(x)))
})

test_that("Beckers AU is quarterly (dates spaced by 3 months)", {
  x <- mp_shock("beckers_au")
  gaps <- as.integer(diff(x$date))
  # Quarterly spacing: roughly 90 days; allow 85-95 tolerance
  expect_true(median(gaps) > 85L && median(gaps) < 95L)
})

test_that("UK series all start in 1997 or later", {
  for (s in c("ukmpd", "cesa_bianchi_uk", "cloyne_hurtgen_uk")) {
    x <- mp_shock(s)
    expect_true(min(x$date) >= as.Date("1997-01-01"))
  }
})

test_that("AU series cover pre-GFC and GFC periods", {
  for (s in c("hambur_haque_au", "beckers_au")) {
    x <- mp_shock(s)
    expect_true(min(x$date) < as.Date("2008-01-01"))
    expect_true(max(x$date) > as.Date("2009-12-31"))
  }
})
