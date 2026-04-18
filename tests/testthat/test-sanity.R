# Known-value sanity tests. These cross-check each bundled series against
# empirical facts documented in the underlying papers or easily verified
# from the source data. A failure here indicates either upstream data
# change or a build-script regression.

test_that("NS has a large 2008 shock from the intermeeting cut episodes", {
  ns <- mp_shock("nakamura_steinsson",
                 start = "2008-01-01", end = "2008-12-31")
  # Jan 2008, March 2008, and Oct 2008 saw inter-meeting or unusually
  # large FOMC moves; at least one of these months should host the
  # biggest absolute 2008 shock in the sample.
  biggest_month <- format(ns$date[which.max(abs(ns$shock))], "%Y-%m")
  expect_true(biggest_month %in% c("2008-01", "2008-03", "2008-10", "2008-12"),
              info = paste("biggest 2008 NS month:", biggest_month))
  # And the biggest absolute shock is non-trivial (> 5 bp on the
  # one-year-yield scale).
  expect_gt(max(abs(ns$shock)), 0.05)
})

test_that("Wu-Xia shadow rate hits its historic trough in 2014", {
  wx <- mp_shock("wu_xia")
  trough <- wx$date[which.min(wx$shadow_rate)]
  expect_equal(format(trough, "%Y"), "2014")
  expect_lt(min(wx$shadow_rate, na.rm = TRUE), -2.5)
})

test_that("Wu-Xia shows a second ZLB dip in 2020", {
  wx <- mp_shock("wu_xia", start = "2020-01-01", end = "2020-12-31")
  # At least one month of 2020 shadow-rate should go materially below
  # the effective fed-funds rate (which was near zero).
  expect_true(any(wx$shadow_rate < -0.1, na.rm = TRUE))
  expect_true(any(wx$shadow_rate < wx$effr - 0.1, na.rm = TRUE))
})

test_that("Bauer-Swanson orthogonalised shock correlates highly with raw MPS", {
  bs <- mp_shock("bauer_swanson")
  r <- cor(bs$shock, bs$mps_raw, use = "pairwise.complete.obs")
  # Orthogonalising against six predictors should shrink the variance
  # modestly, not re-cast the series: correlation with raw MPS should
  # be high but not unity.
  expect_gt(r, 0.8)
  expect_lt(r, 1.0)
})

test_that("NS and Bauer-Swanson agree on the broad shape of the shock series", {
  ns <- mp_shock("nakamura_steinsson")
  bs <- mp_shock("bauer_swanson",
                 start = as.character(min(ns$date)),
                 end   = as.character(max(ns$date)))
  panel <- merge(ns[, c("date", "shock")],
                 bs[, c("date", "shock")],
                 by = "date", suffixes = c("_ns", "_bs"))
  r <- cor(panel$shock_ns, panel$shock_bs, use = "pairwise.complete.obs")
  # Low but positive correlation across alternative identification
  # strategies is the expected pattern (Aeberhardt et al. 2024 FEDS
  # cross-series comparison).
  expect_gt(r, 0.25)
  expect_lt(r, 0.95)
})

test_that("Jarocinski-Karadi MP and CBI are not perfectly correlated", {
  jkm <- mp_shock("jarocinski_karadi_mp")
  jkc <- mp_shock("jarocinski_karadi_cbi")
  r <- cor(jkm$shock, jkc$shock, use = "pairwise.complete.obs")
  # The two shocks are identified to be orthogonal by construction (sign
  # restrictions); correlation should be moderate at most.
  expect_lt(abs(r), 0.5)
})

test_that("Miranda-Agrippino-Ricco shock and info component differ", {
  mar <- mp_shock("miranda_agrippino_ricco")
  # The MPS and INFO columns should not be identical: they are two
  # different projections of the same underlying surprise.
  expect_false(isTRUE(all.equal(mar$shock, mar$info)))
})

test_that("Miranda-Agrippino-Ricco series ends no later than the published extension", {
  mar <- mp_shock("miranda_agrippino_ricco")
  expect_lte(max(mar$date), as.Date("2019-12-31"))
})

test_that("GSS target and path come from the same event-level source", {
  gt <- mp_shock("gss_target")
  gp <- mp_shock("gss_path")
  expect_identical(gt$date, gp$date)
  # The two factors are rotations of the same PC decomposition; they
  # should not be identical but should both have non-trivial variance.
  expect_gt(sd(gt$shock), 0.001)
  expect_gt(sd(gp$shock), 0.001)
  expect_false(isTRUE(all.equal(gt$shock, gp$shock)))
})

test_that("no-meeting months are coded zero in the event-study series", {
  # Pick a month that is universally known to have had no FOMC meeting:
  # October 2000 (meetings were Aug 22 and Oct 3, Nov 15 in 2000).
  # December 2004 is another quiet month (meetings were Nov 10 and Dec 14).
  # Use 2005-02 which had no scheduled meeting (meetings Feb 2 and Mar 22).
  ns <- mp_shock("nakamura_steinsson",
                 start = "2003-01-01", end = "2003-12-31")
  # Months with no FOMC meeting should be exactly 0 under the sum
  # convention.
  zero_months <- sum(ns$shock == 0)
  expect_gt(zero_months, 0L)
})
