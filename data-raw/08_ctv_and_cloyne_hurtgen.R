# Build data/cesa_bianchi_uk.rda and data/cloyne_hurtgen_uk.rda
#
# Source file: Cesa-Bianchi, A., Thwaites, G., & Vicondoa, A. (2020).
# "Monetary policy transmission in the United Kingdom: A high frequency
# identification approach." European Economic Review 123: 103375.
# DOI: 10.1016/j.euroecorev.2020.103375
#
# Author-hosted workbook CTV_MonPolTransmission.xls contains two series:
# * High frequency surprises (Cesa-Bianchi-Thwaites-Vicondoa, 1997m6 to 2015m1)
# * Extension of Cloyne and Hurtgen (2016) narrative shocks, 1997m6 to 2007m12
#
# Cloyne-Hurtgen original: Cloyne, J., & Hurtgen, P. (2016). "The Macroeconomic
# Effects of Monetary Policy: A New Measure for the United Kingdom." AEJ:Macro
# 8(4): 75-102. DOI: 10.1257/mac.20150093
#
# The monthly format in column 1 is "YYYYmM" (e.g. "1997m6"). Months with no
# surprise event have zero for the CTV column; narrative series is NA after
# 2007.

library(readxl)

raw_xls <- "data-raw/cesa_bianchi_uk.xls"
stopifnot(file.exists(raw_xls))

d <- readxl::read_excel(raw_xls, sheet = "DATA", skip = 6)
names(d) <- c("period", "hfi", "narrative")

# Parse YYYYmM into first-of-month Date
parse_period <- function(x) {
  parts <- strsplit(x, "m", fixed = TRUE)
  years  <- vapply(parts, function(p) as.integer(p[1]), integer(1))
  months <- vapply(parts, function(p) as.integer(p[2]), integer(1))
  as.Date(sprintf("%04d-%02d-01", years, months))
}

d$date <- parse_period(d$period)
d <- d[!is.na(d$date), , drop = FALSE]
d <- d[order(d$date), , drop = FALSE]

# Build cesa_bianchi_uk from HFI column
out_ctv <- data.frame(
  date = d$date,
  shock = as.numeric(d$hfi),
  series = "cesa_bianchi_uk",
  stringsAsFactors = FALSE
)
row.names(out_ctv) <- NULL
class(out_ctv) <- c("mp_shock", "data.frame")
attr(out_ctv, "series") <- "cesa_bianchi_uk"
attr(out_ctv, "frequency") <- "monthly"
attr(out_ctv, "units") <- "percentage points"
attr(out_ctv, "source_doi") <- "10.1016/j.euroecorev.2020.103375"
attr(out_ctv, "source_url") <- "https://sites.google.com/site/ambropo/publications"
attr(out_ctv, "license") <- "Author-hosted; cite Cesa-Bianchi, Thwaites, Vicondoa (2020)"
attr(out_ctv, "downloaded") <- Sys.Date()

cesa_bianchi_uk <- out_ctv

# Build cloyne_hurtgen_uk from narrative column (drop trailing NAs)
narr <- d[!is.na(d$narrative), c("date", "narrative"), drop = FALSE]
out_ch <- data.frame(
  date = narr$date,
  shock = as.numeric(narr$narrative),
  series = "cloyne_hurtgen_uk",
  stringsAsFactors = FALSE
)
row.names(out_ch) <- NULL
class(out_ch) <- c("mp_shock", "data.frame")
attr(out_ch, "series") <- "cloyne_hurtgen_uk"
attr(out_ch, "frequency") <- "monthly"
attr(out_ch, "units") <- "percentage points"
attr(out_ch, "source_doi") <- "10.1257/mac.20150093"
attr(out_ch, "source_url") <- "https://www.openicpsr.org/openicpsr/project/114114/version/V1/view"
attr(out_ch, "license") <- "openICPSR project 114114; citation required"
attr(out_ch, "downloaded") <- Sys.Date()

cloyne_hurtgen_uk <- out_ch

if (!dir.exists("data")) dir.create("data")
save(cesa_bianchi_uk,    file = "data/cesa_bianchi_uk.rda",    compress = "xz", version = 3)
save(cloyne_hurtgen_uk,  file = "data/cloyne_hurtgen_uk.rda",  compress = "xz", version = 3)

message(sprintf("cesa_bianchi_uk: %d obs, %s to %s",
                nrow(cesa_bianchi_uk),
                format(min(cesa_bianchi_uk$date)),
                format(max(cesa_bianchi_uk$date))))
message(sprintf("cloyne_hurtgen_uk: %d obs, %s to %s",
                nrow(cloyne_hurtgen_uk),
                format(min(cloyne_hurtgen_uk$date)),
                format(max(cloyne_hurtgen_uk$date))))
