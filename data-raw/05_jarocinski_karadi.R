# Build data/jarocinski_karadi_mp.rda and data/jarocinski_karadi_cbi.rda
#
# Source: Jarocinski, M., & Karadi, P. (2020). "Deconstructing Monetary
# Policy Surprises: The Role of Information Shocks." American Economic
# Journal: Macroeconomics 12(2): 1-43. DOI: 10.1257/mac.20180090
#
# Data: Marek Jarocinski's maintained update for the US Fed,
# https://github.com/marekjarocinski/jkshocks_update_fed_202401
# File: shocks_fed_jk_m.csv
#
# The Jarocinski-Karadi decomposition identifies two shocks on FOMC dates
# via sign restrictions on the joint response of short-rate and stock
# prices:
# * MP: "pure" monetary policy shock (co-moves short-rate and stocks oppositely)
# * CBI: central bank information shock (co-moves short-rate and stocks
#   in the same direction, interpreted as information about the economy)
#
# The CSV contains both "poor man's" (mutually exclusive) and "median"
# (both shocks can co-occur) decompositions. We use the median version
# (MP_median, CBI_median) as the standard choice.

raw_csv <- "data-raw/jk_fed_monthly.csv"
stopifnot(file.exists(raw_csv))

d <- read.csv(raw_csv, stringsAsFactors = FALSE)

d$date <- as.Date(sprintf("%d-%02d-01", as.integer(d$year),
                          as.integer(d$month)))
d$mp   <- as.numeric(d$MP_median)
d$cbi  <- as.numeric(d$CBI_median)
d <- d[!is.na(d$date), , drop = FALSE]
d <- d[order(d$date), , drop = FALSE]

build_one <- function(series_id, value_col) {
  out <- data.frame(
    date = d$date,
    shock = d[[value_col]],
    series = series_id,
    stringsAsFactors = FALSE
  )
  row.names(out) <- NULL
  class(out) <- c("mp_shock", "data.frame")
  attr(out, "series") <- series_id
  attr(out, "frequency") <- "monthly"
  attr(out, "units") <- "percentage points"
  attr(out, "source_doi") <- "10.1257/mac.20180090"
  attr(out, "source_url") <- "https://github.com/marekjarocinski/jkshocks_update_fed_202401"
  attr(out, "license") <- "Academic research data; cite Jarocinski and Karadi (2020)"
  attr(out, "downloaded") <- Sys.Date()
  out
}

jarocinski_karadi_mp  <- build_one("jarocinski_karadi_mp",  "mp")
jarocinski_karadi_cbi <- build_one("jarocinski_karadi_cbi", "cbi")

stopifnot(nrow(jarocinski_karadi_mp) > 100, nrow(jarocinski_karadi_cbi) > 100)

if (!dir.exists("data")) dir.create("data")
save(jarocinski_karadi_mp,  file = "data/jarocinski_karadi_mp.rda",
     compress = "xz", version = 3)
save(jarocinski_karadi_cbi, file = "data/jarocinski_karadi_cbi.rda",
     compress = "xz", version = 3)

message(sprintf("jarocinski_karadi_mp:  %d obs, %s to %s",
                nrow(jarocinski_karadi_mp),
                format(min(jarocinski_karadi_mp$date)),
                format(max(jarocinski_karadi_mp$date))))
message(sprintf("jarocinski_karadi_cbi: %d obs, %s to %s",
                nrow(jarocinski_karadi_cbi),
                format(min(jarocinski_karadi_cbi$date)),
                format(max(jarocinski_karadi_cbi$date))))
