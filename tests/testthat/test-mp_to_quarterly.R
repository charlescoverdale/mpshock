test_that("mp_to_quarterly returns quarter-start dates", {
  q <- mp_to_quarterly(mp_shock("nakamura_steinsson"), method = "sum")
  expect_s3_class(q, "mp_shock")
  expect_true(all(as.integer(format(q$date, "%m")) %in% c(1L, 4L, 7L, 10L)))
})

test_that("quarterly sum equals sum of underlying monthly shocks", {
  m <- mp_shock("nakamura_steinsson",
                start = "2008-01-01", end = "2008-12-31")
  q <- mp_to_quarterly(m, method = "sum")
  expect_equal(nrow(q), 4L)
  expect_equal(sum(q$shock), sum(m$shock))
})

test_that("quarterly mean method gives sensible magnitudes", {
  m <- mp_shock("nakamura_steinsson",
                start = "2008-01-01", end = "2008-12-31")
  q_sum  <- mp_to_quarterly(m, method = "sum")
  q_mean <- mp_to_quarterly(m, method = "mean")
  expect_equal(q_mean$shock * 3, q_sum$shock, tolerance = 1e-8)
})

test_that("quarterly end method returns last monthly value in each quarter", {
  wx <- mp_shock("wu_xia", start = "2010-01-01", end = "2010-06-30")
  q_end <- mp_to_quarterly(wx, method = "end")
  expect_equal(nrow(q_end), 2L)
  expect_equal(q_end$shadow_rate,
               wx$shadow_rate[wx$date %in% as.Date(c("2010-03-01", "2010-06-01"))])
})
