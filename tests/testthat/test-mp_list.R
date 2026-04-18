test_that("mp_list returns the expected schema", {
  m <- mp_list()
  expect_s3_class(m, "data.frame")
  expect_gte(nrow(m), 8L)
  expect_named(
    m,
    c("series", "author", "country", "frequency", "type",
      "start", "end", "n", "doi", "source_url", "description"),
    ignore.order = TRUE
  )
})

test_that("mp_list reports every bundled series", {
  m <- mp_list()
  required <- c(
    # US
    "nakamura_steinsson", "bauer_swanson",
    "gss_target", "gss_path",
    "jarocinski_karadi_mp", "jarocinski_karadi_cbi",
    "miranda_agrippino_ricco", "wu_xia",
    # UK
    "ukmpd", "cesa_bianchi_uk", "cloyne_hurtgen_uk",
    # AU
    "hambur_haque_au", "beckers_au"
  )
  for (s in required) {
    expect_true(s %in% m$series, info = paste("missing:", s))
  }
})

test_that("mp_list covers three countries", {
  m <- mp_list()
  expect_setequal(unique(m$country), c("US", "UK", "AU"))
})

test_that("mp_list returns 13 series in v0.1.0", {
  m <- mp_list()
  expect_equal(nrow(m), 13L)
})

test_that("mp_list dates and counts are sensible", {
  m <- mp_list()
  expect_s3_class(m$start, "Date")
  expect_s3_class(m$end, "Date")
  expect_true(all(m$end >= m$start))
  expect_true(all(m$n > 0L))
  # `beckers_au` has no DOI (RBA RDP); every other series does
  expect_true(all(m$doi[m$series != "beckers_au"] != ""))
  expect_true(all(grepl("^https?://", m$source_url)))
})

test_that("mp_list type field classifies series correctly", {
  m <- mp_list()
  expect_true(all(m$type %in%
                    c("shock", "shadow_rate", "information",
                      "surprise", "narrative")))
  expect_equal(m$type[m$series == "wu_xia"], "shadow_rate")
  expect_equal(m$type[m$series == "jarocinski_karadi_cbi"], "information")
  expect_equal(m$type[m$series == "cloyne_hurtgen_uk"], "narrative")
  expect_equal(m$type[m$series == "beckers_au"], "narrative")
})

test_that("mp_list frequency covers monthly and quarterly", {
  m <- mp_list()
  expect_true("monthly" %in% m$frequency)
  expect_true("quarterly" %in% m$frequency)
  expect_equal(m$frequency[m$series == "beckers_au"], "quarterly")
})
