test_that("mp_source returns a one-row data frame with provenance fields", {
  out <- suppressMessages(mp_source("nakamura_steinsson"))
  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 1L)
  expect_named(out,
               c("series", "author", "doi", "source_url", "description"),
               ignore.order = TRUE)
  expect_equal(out$series, "nakamura_steinsson")
  expect_equal(out$doi, "10.1093/qje/qjy004")
})

test_that("mp_source errors on unknown series", {
  expect_error(suppressMessages(mp_source("foo")), "Unknown series")
})
