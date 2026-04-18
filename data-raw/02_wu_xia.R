# Build data/wu_xia.rda
#
# Source: Wu, J. C., & Xia, F. D. (2016). Measuring the Macroeconomic Impact
# of Monetary Policy at the Zero Lower Bound. Journal of Money, Credit and
# Banking 48(2-3): 253-291. DOI: 10.1111/jmcb.12300
#
# Data maintained by the Federal Reserve Bank of Atlanta at
# https://www.atlantafed.org/cqer/research/wu-xia-shadow-federal-funds-rate
# The series is produced as part of US Federal Reserve research and is
# therefore not subject to copyright under 17 U.S.C. S 105 (public domain).
# Bundleable.
#
# The bundled series is the monthly Wu-Xia shadow federal funds rate, with
# the companion effective federal funds rate alongside. The shadow rate is
# the authors' estimate of what the federal funds rate would have been
# during zero-lower-bound episodes (2008-12 to 2015-12 and 2020-03 to 2022-02)
# had policy rates been allowed to go negative. Unit is percentage points,
# annualised.
#
# Note: this is a stance measure (level), not a shock. Users running IRFs
# with shadow rates typically first-difference the series; see the package
# README for the standard recipe.

library(readxl)

raw_xlsx <- "data-raw/WuXiaShadowRate.xlsx"
stopifnot(file.exists(raw_xlsx))

d <- readxl::read_excel(raw_xlsx, sheet = "Data", col_names = TRUE)

# Reshape: drop empty cols, rename, coerce date
d <- d[, c(1, 2, 3)]
names(d) <- c("date", "effr", "shadow_rate")
d$date <- as.Date(d$date)
d$effr <- as.numeric(d$effr)
d$shadow_rate <- as.numeric(d$shadow_rate)

# Keep rows with either effr or shadow_rate observed
d <- d[!(is.na(d$effr) & is.na(d$shadow_rate)), , drop = FALSE]

# First-difference of shadow rate as the "shock" default column: this makes
# the series directly comparable with other mp_shock objects and usable as
# an impulse variable in LPs and VARs. Users who want the level can use
# `shadow_rate`.
d <- d[order(d$date), , drop = FALSE]
d$shock <- c(NA_real_, diff(d$shadow_rate))
d$series <- "wu_xia"

out <- d[, c("date", "shock", "shadow_rate", "effr", "series"), drop = FALSE]
row.names(out) <- NULL

class(out) <- c("mp_shock", "data.frame")
attr(out, "series") <- "wu_xia"
attr(out, "frequency") <- "monthly"
attr(out, "units") <- "percentage points per annum"
attr(out, "source_doi") <- "10.1111/jmcb.12300"
attr(out, "source_url") <- "https://www.atlantafed.org/cqer/research/wu-xia-shadow-federal-funds-rate"
attr(out, "license") <- "Public domain (US Federal Reserve research output)"
attr(out, "downloaded") <- Sys.Date()
attr(out, "note") <- "shock = first difference of shadow_rate"

wu_xia <- out

# Sanity checks
stopifnot(nrow(wu_xia) > 500)
stopifnot(inherits(wu_xia$date, "Date"))
stopifnot(all(c("date", "shock", "shadow_rate", "effr", "series") %in% names(wu_xia)))

# Save
if (!dir.exists("data")) dir.create("data")
save(wu_xia, file = "data/wu_xia.rda", compress = "xz", version = 3)

message(sprintf(
  "wu_xia: %d obs, %s to %s, shadow_rate range [%.2f, %.2f]",
  nrow(wu_xia),
  format(min(wu_xia$date)),
  format(max(wu_xia$date)),
  min(wu_xia$shadow_rate, na.rm = TRUE),
  max(wu_xia$shadow_rate, na.rm = TRUE)
))
