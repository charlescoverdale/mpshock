# Build data/ukmpd.rda
#
# Source: Braun, R., Miranda-Agrippino, S., & Saha, T. (2025). "Measuring
# Monetary Policy in the UK: The UK Monetary Policy Event-Study Database."
# Journal of Monetary Economics 149.
# Working paper: Bank of England Staff Working Paper No. 1050 (2023).
#
# Data: BoE-hosted UKMPD workbook at
# https://www.bankofengland.co.uk/-/media/boe/files/working-paper/2023/
# measuring-monetary-policy-in-the-uk-the-ukmpesd.xlsx
#
# The UKMPD is the UK equivalent of the GSS (2005) / Swanson (2021)
# three-factor decomposition of high-frequency monetary policy surprises
# around Bank of England MPC announcements. Factors are: Target (current
# Bank Rate surprise), Path (short-term forward-rate guidance), and QE
# (long-end asset-purchase effect). Event-level factors are aggregated to
# monthly by summation; months with no MPC meeting are coded zero.

library(readxl)

raw_xlsx <- "data-raw/ukmpd.xlsx"
stopifnot(file.exists(raw_xlsx))

d <- readxl::read_excel(raw_xlsx, sheet = "factors", col_names = TRUE)
d$Datetime <- as.Date(d$Datetime)
d$isMPC <- as.integer(d$isMPC)
d$Target <- as.numeric(d$Target)
d$Path <- as.numeric(d$Path)
d$QE <- as.numeric(d$QE)

# Keep MPC-announcement rows
mpc <- d[!is.na(d$isMPC) & d$isMPC == 1L & !is.na(d$Datetime), ,
         drop = FALSE]

# Aggregate to monthly: sum within calendar month, zero for no-meeting months
first_date <- min(mpc$Datetime, na.rm = TRUE)
last_date  <- max(mpc$Datetime, na.rm = TRUE)
monthly_seq <- seq(
  as.Date(format(first_date, "%Y-%m-01")),
  as.Date(format(last_date, "%Y-%m-01")),
  by = "month"
)

mpc$month_start <- as.Date(format(mpc$Datetime, "%Y-%m-01"))
agg_target <- aggregate(Target ~ month_start, data = mpc, FUN = sum, na.rm = TRUE)
agg_path   <- aggregate(Path   ~ month_start, data = mpc, FUN = sum, na.rm = TRUE)
agg_qe     <- aggregate(QE     ~ month_start, data = mpc, FUN = sum, na.rm = TRUE)

out <- data.frame(
  date = monthly_seq,
  shock = 0,
  path = 0,
  qe = 0,
  stringsAsFactors = FALSE
)
out$shock[match(agg_target$month_start, out$date)] <- agg_target$Target
out$path[match(agg_path$month_start,   out$date)]  <- agg_path$Path
out$qe[match(agg_qe$month_start,       out$date)]  <- agg_qe$QE
out$series <- "ukmpd"

class(out) <- c("mp_shock", "data.frame")
attr(out, "series") <- "ukmpd"
attr(out, "frequency") <- "monthly"
attr(out, "units") <- "percentage points"
attr(out, "source_doi") <- "10.1016/j.jmoneco.2024.103645"
attr(out, "source_url") <- "https://www.bankofengland.co.uk/working-paper/2023/measuring-monetary-policy-in-the-uk-ukmpd"
attr(out, "license") <- "Bank of England staff working paper supplement"
attr(out, "downloaded") <- Sys.Date()

ukmpd <- out

stopifnot(nrow(ukmpd) > 100)
if (!dir.exists("data")) dir.create("data")
save(ukmpd, file = "data/ukmpd.rda", compress = "xz", version = 3)

message(sprintf("ukmpd: %d obs, %s to %s", nrow(ukmpd),
                format(min(ukmpd$date)), format(max(ukmpd$date))))
