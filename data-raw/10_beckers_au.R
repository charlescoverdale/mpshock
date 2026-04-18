# Build data/beckers_au.rda
#
# Source: Beckers, B. (2020). "Credit Spreads, Monetary Policy and the
# Price Puzzle in Australia." Reserve Bank of Australia Research
# Discussion Paper 2020-01.
#
# Data: RBA supplementary ZIP, Results/rr_shocks.xlsx
# https://www.rba.gov.au/publications/rdp/2020/2020-01/
#   rdp-2020-01-supplementary-information.zip
# License: Creative Commons Attribution 4.0 International
# (https://www.rba.gov.au/copyright/).
#
# The Beckers series is a Romer-Romer-style identified monetary-policy
# shock for Australia constructed from RBA cash-rate changes orthogonal
# to the Bank's internal forecasts (Bishop-Tulip, "BT") and to
# cash-rate-futures-implied expectations ("BT-CS1" through "BT-CS4").
# The headline series "BT-CS" is BT further augmented with credit-spread
# information (Beckers's contribution).
# Quarterly frequency, 1994-Q1 to 2018-Q4.

library(readxl)

raw_xlsx <- "data-raw/beckers_extract/rr_shocks.xlsx"
stopifnot(file.exists(raw_xlsx))

d <- readxl::read_excel(raw_xlsx, sheet = "Sheet1", col_names = TRUE)
d$date <- as.Date(d$Date)

# shock    = BT-CS (Beckers's credit-spread-augmented RR shock, preferred)
# bt       = Bishop-Tulip RR shock (pre-credit-spread version)
# rate_chg = actual cash rate change
d$shock    <- as.numeric(d$`BT-CS`)
d$bt       <- as.numeric(d$`Bishop-Tulip (BT)`)
d$rate_chg <- as.numeric(d$`Cash Rate Change`)
d <- d[!is.na(d$date), , drop = FALSE]
d <- d[order(d$date), , drop = FALSE]

out <- d[, c("date", "shock", "bt", "rate_chg"), drop = FALSE]
out$series <- "beckers_au"
row.names(out) <- NULL

class(out) <- c("mp_shock", "data.frame")
attr(out, "series") <- "beckers_au"
attr(out, "frequency") <- "quarterly"
attr(out, "units") <- "percentage points"
attr(out, "source_doi") <- NA_character_
attr(out, "source_url") <- "https://www.rba.gov.au/publications/rdp/2020/2020-01/"
attr(out, "license") <- "CC BY 4.0 (RBA)"
attr(out, "downloaded") <- Sys.Date()

beckers_au <- out

stopifnot(nrow(beckers_au) > 50)
if (!dir.exists("data")) dir.create("data")
save(beckers_au, file = "data/beckers_au.rda", compress = "xz", version = 3)

message(sprintf("beckers_au: %d obs, %s to %s",
                nrow(beckers_au),
                format(min(beckers_au$date)),
                format(max(beckers_au$date))))
