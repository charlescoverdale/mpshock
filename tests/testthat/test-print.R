test_that("print.mp_shock returns x invisibly and emits a header", {
  s <- mp_shock("nakamura_steinsson")
  msgs <- testthat::capture_messages(
    out <- testthat::capture_output(val <- print(s))
  )
  expect_identical(val, s)
  expect_true(any(grepl("<mp_shock>", msgs)))
  expect_true(any(grepl("nakamura_steinsson", msgs)))
})

test_that("format.mp_shock returns a single-string summary", {
  s <- mp_shock("wu_xia")
  fs <- format(s)
  expect_type(fs, "character")
  expect_length(fs, 1L)
  expect_true(grepl("wu_xia", fs))
})
