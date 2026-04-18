test_that("mp_cumulate full cumulative matches cumsum", {
  s <- mp_shock("nakamura_steinsson")
  out <- mp_cumulate(s)
  expect_true("shock_cum" %in% names(out))
  expect_equal(tail(out$shock_cum, 1L), sum(s$shock, na.rm = TRUE))
})

test_that("mp_cumulate window produces rolling sums of the right length", {
  s <- mp_shock("nakamura_steinsson")
  out <- mp_cumulate(s, window = 12L)
  expect_true("shock_roll" %in% names(out))
  expect_equal(length(out$shock_roll), nrow(s))
  # After the first full window, roll should equal rolling sum of 12 months
  idx <- 13L:20L
  for (i in idx) {
    expect_equal(out$shock_roll[i],
                 sum(s$shock[(i - 11L):i], na.rm = TRUE))
  }
})

test_that("mp_cumulate rejects bad window", {
  s <- mp_shock("nakamura_steinsson")
  expect_error(mp_cumulate(s, window = 0), "positive integer")
  expect_error(mp_cumulate(s, window = 1.5), "positive integer")
  expect_error(mp_cumulate(s, window = c(1L, 2L)), "positive integer")
})
