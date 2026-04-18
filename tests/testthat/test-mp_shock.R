test_that("mp_shock returns an mp_shock data frame with required columns", {
  for (s in c("nakamura_steinsson", "bauer_swanson",
              "gss_target", "gss_path",
              "jarocinski_karadi_mp", "jarocinski_karadi_cbi",
              "miranda_agrippino_ricco", "wu_xia",
              "ukmpd", "cesa_bianchi_uk", "cloyne_hurtgen_uk",
              "hambur_haque_au", "beckers_au")) {
    x <- mp_shock(s)
    expect_s3_class(x, "mp_shock")
    expect_s3_class(x, "data.frame")
    expect_true(all(c("date", "shock", "series") %in% names(x)),
                info = paste("series:", s))
    expect_s3_class(x$date, "Date")
    expect_type(x$shock, "double")
    expect_identical(unique(x$series), s, info = paste("series:", s))
  }
})

test_that("Nakamura-Steinsson series has the documented span", {
  ns <- mp_shock("nakamura_steinsson")
  expect_equal(as.character(min(ns$date)), "2000-02-01")
  expect_equal(as.character(max(ns$date)), "2014-03-01")
  expect_gt(nrow(ns), 150L)
})

test_that("Nakamura-Steinsson shocks sum to approximately zero", {
  ns <- mp_shock("nakamura_steinsson")
  expect_lt(abs(sum(ns$shock, na.rm = TRUE)), 0.01)
})

test_that("Bauer-Swanson series has the documented span and columns", {
  bs <- mp_shock("bauer_swanson")
  expect_true(all(c("date", "shock", "mps_raw", "series") %in% names(bs)))
  expect_equal(as.character(min(bs$date)), "1988-02-01")
  expect_gt(nrow(bs), 400L)
})

test_that("GSS target and path have the same dates and lengths", {
  gt <- mp_shock("gss_target")
  gp <- mp_shock("gss_path")
  expect_equal(nrow(gt), nrow(gp))
  expect_identical(gt$date, gp$date)
})

test_that("Jarocinski-Karadi MP and CBI have the same dates", {
  jkm <- mp_shock("jarocinski_karadi_mp")
  jkc <- mp_shock("jarocinski_karadi_cbi")
  expect_equal(nrow(jkm), nrow(jkc))
  expect_identical(jkm$date, jkc$date)
})

test_that("Miranda-Agrippino-Ricco has the documented span and info column", {
  mar <- mp_shock("miranda_agrippino_ricco")
  expect_true("info" %in% names(mar))
  expect_equal(as.character(min(mar$date)), "1991-01-01")
  expect_equal(as.character(max(mar$date)), "2019-06-01")
})

test_that("Wu-Xia series has the documented span and columns", {
  wx <- mp_shock("wu_xia")
  expect_true(all(c("date", "shock", "shadow_rate", "effr", "series")
                  %in% names(wx)))
  expect_equal(as.character(min(wx$date)), "1960-01-01")
  expect_equal(as.character(max(wx$date)), "2022-02-01")
})

test_that("Wu-Xia shadow rate is below effective rate during ZLB", {
  wx <- mp_shock("wu_xia")
  zlb <- wx[wx$date >= as.Date("2009-01-01") &
              wx$date <= as.Date("2015-12-01"), ]
  expect_true(mean(zlb$shadow_rate, na.rm = TRUE) <
                mean(zlb$effr, na.rm = TRUE))
})

test_that("mp_shock date filters work", {
  ns <- mp_shock("nakamura_steinsson",
                 start = "2008-01-01", end = "2008-12-31")
  expect_true(all(ns$date >= as.Date("2008-01-01")))
  expect_true(all(ns$date <= as.Date("2008-12-31")))
  expect_equal(nrow(ns), 12L)
})

test_that("mp_shock errors on unknown series", {
  expect_error(mp_shock("does_not_exist"), "Unknown series")
})

test_that("mp_shock errors on non-scalar input", {
  expect_error(mp_shock(c("nakamura_steinsson", "wu_xia")),
               "single character string")
  expect_error(mp_shock(1L), "single character string")
})
