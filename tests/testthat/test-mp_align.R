test_that("mp_align left-joins shock onto target", {
  shock <- mp_shock("nakamura_steinsson")
  target <- data.frame(
    date = seq(as.Date("2008-01-01"), as.Date("2008-12-01"), by = "month"),
    gdp_growth = seq_len(12L) / 10
  )
  out <- mp_align(shock, target)
  expect_equal(nrow(out), nrow(target))
  expect_true("shock" %in% names(out))
  expect_true("gdp_growth" %in% names(out))
})

test_that("mp_align fill_zero replaces NAs with 0", {
  shock <- mp_shock("nakamura_steinsson")
  target <- data.frame(
    date = seq(as.Date("2015-01-01"), as.Date("2015-12-01"), by = "month"),
    x = 1:12
  )
  out <- mp_align(shock, target, fill_zero = TRUE)
  expect_false(anyNA(out$shock))
  expect_true(all(out$shock == 0))
})

test_that("mp_align errors on bad inputs", {
  shock <- mp_shock("nakamura_steinsson")
  expect_error(mp_align("not a shock", data.frame(date = Sys.Date())),
               "mp_shock")
  expect_error(mp_align(shock, "not a frame"), "must be a data frame")
  expect_error(mp_align(shock, data.frame(x = 1)), "not found")
})
