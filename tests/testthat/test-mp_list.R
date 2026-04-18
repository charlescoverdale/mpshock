test_that("mp_list returns the expected schema", {
  m <- mp_list()
  expect_s3_class(m, "data.frame")
  expect_gte(nrow(m), 2L)
  expect_named(
    m,
    c("series", "author", "country", "frequency", "type",
      "start", "end", "n", "doi", "source_url", "description"),
    ignore.order = TRUE
  )
})

test_that("mp_list reports every bundled series", {
  m <- mp_list()
  expect_true("nakamura_steinsson" %in% m$series)
  expect_true("wu_xia" %in% m$series)
})

test_that("mp_list dates and counts are sensible", {
  m <- mp_list()
  expect_s3_class(m$start, "Date")
  expect_s3_class(m$end, "Date")
  expect_true(all(m$end >= m$start))
  expect_true(all(m$n > 0L))
  expect_true(all(m$doi != ""))
  expect_true(all(grepl("^https?://", m$source_url)))
})
