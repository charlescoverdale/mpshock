test_that("mp_shock returns an mp_shock data frame with required columns", {
  ns <- mp_shock("nakamura_steinsson")
  expect_s3_class(ns, "mp_shock")
  expect_s3_class(ns, "data.frame")
  expect_true(all(c("date", "shock", "series") %in% names(ns)))
  expect_s3_class(ns$date, "Date")
  expect_type(ns$shock, "double")
  expect_identical(unique(ns$series), "nakamura_steinsson")
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

test_that("Wu-Xia series has the documented span and columns", {
  wx <- mp_shock("wu_xia")
  expect_s3_class(wx, "mp_shock")
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
