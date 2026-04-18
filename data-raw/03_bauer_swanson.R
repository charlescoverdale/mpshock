# Build data/bauer_swanson.rda
#
# Source: Bauer, M. D., & Swanson, E. T. (2023). "An Alternative Explanation
# for the 'Fed Information Effect'." American Economic Review 113(3):
# 664-700. DOI: 10.1257/aer.20200994
#
# Data maintained by the Federal Reserve Bank of San Francisco at
# https://www.frbsf.org/research-and-insights/data-and-indicators/
# monetary-policy-surprises/ as part of public research output. FRBSF
# research materials are treated as public information.
#
# The bundled series is the monthly orthogonalised monetary policy surprise
# (MPS_ORTH), which removes predictability from public economic information
# available before the FOMC meeting. This is the headline series used in
# the paper's impulse response exercises.
#
# Columns:
# * shock:     MPS_ORTH, orthogonalised monetary policy surprise (pp)
# * mps_raw:   MPS, raw high-frequency surprise summed within the month (pp)
# * date:      first day of the calendar month
# * series:    "bauer_swanson"

library(readxl)

raw_xlsx <- "data-raw/bauer_swanson.xlsx"
stopifnot(file.exists(raw_xlsx))

d <- readxl::read_excel(raw_xlsx, sheet = "Monthly (update 2023)",
                        col_names = TRUE)

d$date <- as.Date(sprintf("%d-%02d-01", as.integer(d$Year),
                          as.integer(d$Month)))
d$shock <- as.numeric(d$MPS_ORTH)
d$mps_raw <- as.numeric(d$MPS)
d$series <- "bauer_swanson"

# Drop any rows with no date or shock
d <- d[!is.na(d$date) & !is.na(d$shock), ,  drop = FALSE]
d <- d[order(d$date), , drop = FALSE]

out <- d[, c("date", "shock", "mps_raw", "series"), drop = FALSE]
row.names(out) <- NULL

class(out) <- c("mp_shock", "data.frame")
attr(out, "series") <- "bauer_swanson"
attr(out, "frequency") <- "monthly"
attr(out, "units") <- "percentage points"
attr(out, "source_doi") <- "10.1257/aer.20200994"
attr(out, "source_url") <- "https://www.frbsf.org/research-and-insights/data-and-indicators/monetary-policy-surprises/"
attr(out, "license") <- "Federal Reserve Bank of San Francisco research output"
attr(out, "downloaded") <- Sys.Date()

bauer_swanson <- out

stopifnot(nrow(bauer_swanson) > 100)
stopifnot(inherits(bauer_swanson$date, "Date"))

if (!dir.exists("data")) dir.create("data")
save(bauer_swanson, file = "data/bauer_swanson.rda",
     compress = "xz", version = 3)

message(sprintf(
  "bauer_swanson: %d obs, %s to %s, MPS_ORTH range [%.4f, %.4f]",
  nrow(bauer_swanson),
  format(min(bauer_swanson$date)),
  format(max(bauer_swanson$date)),
  min(bauer_swanson$shock, na.rm = TRUE),
  max(bauer_swanson$shock, na.rm = TRUE)
))
