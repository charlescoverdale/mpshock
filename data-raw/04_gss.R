# Build data/gss_target.rda and data/gss_path.rda
#
# Source: Swanson, E. T. (2021). "Measuring the Effects of Federal Reserve
# Forward Guidance and Asset Purchases on Financial Markets." Journal of
# Monetary Economics 118: 32-53. Extension of Gurkaynak, Sack, and Swanson
# (2005), "Do Actions Speak Louder Than Words? The Response of Asset
# Prices to Monetary Policy Actions and Statements", International Journal
# of Central Banking 1(1): 55-93.
#
# Data: Eric Swanson's UCI page,
# https://sites.socsci.uci.edu/~swanson2/papers/pre-and-post-ZLB-factors-extended.xlsx
#
# The XLSX contains the three-factor decomposition (Federal Funds Rate,
# Forward Guidance, LSAP) per FOMC event from 1991-07 to 2019-06.
#
# Column mapping to mpshock:
# * gss_target = Federal Funds Rate factor (conceptually equivalent to the
#   original GSS 2005 "target" factor capturing current-meeting surprises)
# * gss_path = Forward Guidance factor (conceptually equivalent to the
#   original GSS 2005 "path" factor capturing forward-guidance surprises)
#
# Both are returned at monthly frequency by summing event-level values
# within each calendar month (zero in months with no FOMC meeting).

library(readxl)

raw_xlsx <- "data-raw/gss_swanson.xlsx"
stopifnot(file.exists(raw_xlsx))

# First two rows are headers; data starts on row 3. Column 1 is Excel
# serial date; columns 2-5 are FFR, Forward Guidance, LSAP, -LSAP factors.
d <- readxl::read_excel(raw_xlsx, sheet = "Data", col_names = FALSE,
                        skip = 2)
names(d) <- c("excel_date", "ffr", "fg", "lsap", "nlsap")

d$date <- as.Date(as.numeric(d$excel_date), origin = "1899-12-30")
d$ffr <- as.numeric(d$ffr)
d$fg  <- as.numeric(d$fg)
d <- d[!is.na(d$date), c("date", "ffr", "fg"), drop = FALSE]

# Aggregate to monthly: sum within calendar month; zero if no meeting
monthly_span <- seq(
  as.Date(format(min(d$date), "%Y-%m-01")),
  as.Date(format(max(d$date), "%Y-%m-01")),
  by = "month"
)
d$month_start <- as.Date(format(d$date, "%Y-%m-01"))

agg_ffr <- aggregate(ffr ~ month_start, data = d, FUN = sum, na.rm = TRUE)
agg_fg  <- aggregate(fg  ~ month_start, data = d, FUN = sum, na.rm = TRUE)

build_one <- function(series_id, values_df, value_col) {
  out <- data.frame(date = monthly_span, shock = 0, stringsAsFactors = FALSE)
  m <- match(values_df$month_start, out$date)
  out$shock[m] <- values_df[[value_col]]
  out$series <- series_id
  row.names(out) <- NULL
  class(out) <- c("mp_shock", "data.frame")
  attr(out, "series") <- series_id
  attr(out, "frequency") <- "monthly"
  attr(out, "units") <- "percentage points"
  attr(out, "source_doi") <- "10.1016/j.jmoneco.2020.09.003"
  attr(out, "source_url") <- "https://sites.socsci.uci.edu/~swanson2/"
  attr(out, "license") <- "Academic research data; cite Swanson (2021)"
  attr(out, "downloaded") <- Sys.Date()
  out
}

gss_target <- build_one("gss_target", agg_ffr, "ffr")
gss_path   <- build_one("gss_path",   agg_fg,  "fg")

stopifnot(nrow(gss_target) > 100, nrow(gss_path) > 100)

if (!dir.exists("data")) dir.create("data")
save(gss_target, file = "data/gss_target.rda", compress = "xz", version = 3)
save(gss_path,   file = "data/gss_path.rda",   compress = "xz", version = 3)

message(sprintf("gss_target: %d obs, %s to %s",
                nrow(gss_target),
                format(min(gss_target$date)),
                format(max(gss_target$date))))
message(sprintf("gss_path:   %d obs, %s to %s",
                nrow(gss_path),
                format(min(gss_path$date)),
                format(max(gss_path$date))))
