# Build data/hambur_haque_au.rda
#
# Source: Hambur, J., & Haque, Q. (2023). "Monetary Policy Transmission,
# Real Interest Rates and Credit Spreads: Evidence from Australia."
# Reserve Bank of Australia Research Discussion Paper 2023-04.
# Published: Economic Record (2024), DOI 10.1111/1475-4932.12786.
#
# Data: RBA supplementary ZIP at
# https://www.rba.gov.au/publications/rdp/2023/2023-04/
#   rdp-2023-04-supplementary-information.zip
# License: Creative Commons Attribution 4.0 International
# (https://www.rba.gov.au/copyright/).
#
# The baseline monthly shock decomposition has three components per RBA
# cash-rate decision:
# * action (exp_pc1): current-meeting cash-rate surprise
# * path   (exp_pc2): forward-guidance surprise
# * term_premium (tp_dir_pc1): long-end term-premium surprise
# Each is a principal-component rotation of OIS and AGS yield changes
# around RBA board meetings, at monthly frequency.

raw_csv <- "data-raw/hambur_haque_extract/pc_yield_baseline.csv"
stopifnot(file.exists(raw_csv))

d <- read.csv(raw_csv, stringsAsFactors = FALSE, header = TRUE)
# Column 1 is DD/MM/YYYY; column 2 is YYYYmM (monthly label). Use the
# first for precision, parse as Date.
names(d)[1] <- "raw_date"
names(d)[2] <- "period"
d$date <- as.Date(format(as.Date(d$raw_date, format = "%d/%m/%Y"), "%Y-%m-01"))

# Keep rows with valid date and non-missing components
d$action       <- as.numeric(d$exp_pc1)
d$path         <- as.numeric(d$exp_pc2)
d$term_premium <- as.numeric(d$tp_dir_pc1)
d <- d[!is.na(d$date), , drop = FALSE]
d <- d[order(d$date), , drop = FALSE]

# Aggregate to monthly (in case multiple RBA events fell in one month)
agg <- aggregate(
  cbind(action, path, term_premium) ~ date,
  data = d,
  FUN = function(x) sum(x, na.rm = TRUE)
)

# Pad the sequence so months with no meeting get zero rows
monthly_seq <- seq(min(agg$date), max(agg$date), by = "month")
out <- data.frame(date = monthly_seq, stringsAsFactors = FALSE)
m <- match(agg$date, out$date)
out$action       <- 0
out$path         <- 0
out$term_premium <- 0
out$action[m]       <- agg$action
out$path[m]         <- agg$path
out$term_premium[m] <- agg$term_premium
out$shock <- out$action
out$series <- "hambur_haque_au"
out <- out[, c("date", "shock", "action", "path", "term_premium", "series"),
           drop = FALSE]
row.names(out) <- NULL

class(out) <- c("mp_shock", "data.frame")
attr(out, "series") <- "hambur_haque_au"
attr(out, "frequency") <- "monthly"
attr(out, "units") <- "percentage points"
attr(out, "source_doi") <- "10.1111/1475-4932.12786"
attr(out, "source_url") <- "https://www.rba.gov.au/publications/rdp/2023/2023-04/"
attr(out, "license") <- "CC BY 4.0 (RBA)"
attr(out, "downloaded") <- Sys.Date()

hambur_haque_au <- out

stopifnot(nrow(hambur_haque_au) > 100)
if (!dir.exists("data")) dir.create("data")
save(hambur_haque_au, file = "data/hambur_haque_au.rda",
     compress = "xz", version = 3)

message(sprintf("hambur_haque_au: %d obs, %s to %s",
                nrow(hambur_haque_au),
                format(min(hambur_haque_au$date)),
                format(max(hambur_haque_au$date))))
