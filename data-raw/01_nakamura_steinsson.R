# Build data/nakamura_steinsson.rda
#
# Source: Nakamura, E., & Steinsson, J. (2018). High-Frequency Identification
# of Monetary Non-Neutrality. Quarterly Journal of Economics 133(3): 1283-1330.
# DOI: 10.1093/qje/qjy004
#
# Replication archive: Harvard Dataverse doi:10.7910/DVN/HZOXKN
# License: CC0 1.0 Universal (public domain dedication). Bundleable.
#
# The relevant file inside the archive is
# Replication_Online/Matlab/Structural/data/dataForMatlabAltEstTick.csv
# which contains per-FOMC-event observations including the `path` column,
# i.e. the Nakamura-Steinsson "policy news shock": the first principal
# component of five interest-rate futures surprises in a 30-minute window
# around FOMC announcements.
#
# This script takes that FOMC-event file, keeps only rows with FOMCused == 1
# (the scheduled FOMC announcements used in the paper), and aggregates the
# path shocks to monthly frequency by summing within calendar months. Months
# with no FOMC meeting get a zero. Dates are set to the first day of the
# month. Units are percentage points (matching the paper's Table 2).

library(utils)

# Inputs
raw_csv <- "data-raw/ns_extract/dataForMatlabAltEstTick.csv"
stopifnot(file.exists(raw_csv))

raw <- read.csv(raw_csv, stringsAsFactors = FALSE)

# Parse Stata dmy date ("04jan2000")
raw$date <- as.Date(raw$date_daily, format = "%d%b%Y")
if (anyNA(raw$date)) {
  stop("Date parsing produced NAs; inspect raw$date_daily")
}

# Keep FOMC-used event rows
fomc <- raw[raw$FOMCused == 1, c("date", "path"), drop = FALSE]
fomc$path <- as.numeric(fomc$path)

# Aggregate to monthly frequency: sum of path shocks in each calendar month.
# Months with no scheduled FOMC meeting get zero.
first_date <- min(fomc$date, na.rm = TRUE)
last_date  <- max(fomc$date, na.rm = TRUE)
month_seq <- seq(
  as.Date(format(first_date, "%Y-%m-01")),
  as.Date(format(last_date, "%Y-%m-01")),
  by = "month"
)

fomc$month_start <- as.Date(format(fomc$date, "%Y-%m-01"))
agg <- aggregate(path ~ month_start, data = fomc, FUN = sum, na.rm = TRUE)

out <- data.frame(date = month_seq, shock = 0, stringsAsFactors = FALSE)
m <- match(agg$month_start, out$date)
out$shock[m] <- agg$path
out$series <- "nakamura_steinsson"

# Class + package-style attributes
class(out) <- c("mp_shock", "data.frame")
attr(out, "series") <- "nakamura_steinsson"
attr(out, "frequency") <- "monthly"
attr(out, "units") <- "percentage points"
attr(out, "source_doi") <- "10.1093/qje/qjy004"
attr(out, "source_url") <- "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN"
attr(out, "license") <- "CC0 1.0 Universal"
attr(out, "downloaded") <- Sys.Date()

nakamura_steinsson <- out

# Sanity checks
stopifnot(nrow(nakamura_steinsson) >= 100)
stopifnot(all(c("date", "shock", "series") %in% names(nakamura_steinsson)))
stopifnot(inherits(nakamura_steinsson$date, "Date"))
stopifnot(is.numeric(nakamura_steinsson$shock))

# Save
if (!dir.exists("data")) dir.create("data")
save(nakamura_steinsson, file = "data/nakamura_steinsson.rda",
     compress = "xz", version = 3)

message(sprintf(
  "nakamura_steinsson: %d obs, %s to %s, sum of path = %.4f",
  nrow(nakamura_steinsson),
  format(min(nakamura_steinsson$date)),
  format(max(nakamura_steinsson$date)),
  sum(nakamura_steinsson$shock)
))
