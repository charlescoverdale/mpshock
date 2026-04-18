# Build data/miranda_agrippino_ricco.rda
#
# Source: Miranda-Agrippino, S., & Ricco, G. (2021). "The Transmission of
# Monetary Policy Shocks." American Economic Journal: Macroeconomics
# 13(3): 74-107. DOI: 10.1257/mac.20180124
#
# Data: Degasperi and Ricco maintained extension,
# https://github.com/riccardo-degasperi/info-policy-surprises
# File: ff4_instruments_shared.xlsx, sheet "ver_2025"
#
# The informationally-robust monetary policy shock is the component of
# high-frequency FF4 (fourth Eurodollar futures) surprises orthogonal to
# the Greenbook information set, isolating genuinely exogenous policy
# moves from shifts in the Fed's private information about the economy.

library(readxl)

raw_xlsx <- "data-raw/mar_ff4.xlsx"
stopifnot(file.exists(raw_xlsx))

d <- readxl::read_excel(raw_xlsx, sheet = "ver_2025",
                        col_names = FALSE, skip = 1)
names(d) <- c("raw_date", "shock", "info")

# readxl auto-detects the Time column as POSIXct; convert to Date directly
d$date <- as.Date(d$raw_date)
d$shock <- as.numeric(d$shock)
d$info  <- as.numeric(d$info)
d$series <- "miranda_agrippino_ricco"
d <- d[!is.na(d$date), c("date", "shock", "info", "series"), drop = FALSE]
d <- d[order(d$date), , drop = FALSE]

# Align dates to first-of-month for monthly series
d$date <- as.Date(format(d$date, "%Y-%m-01"))

miranda_agrippino_ricco <- d
row.names(miranda_agrippino_ricco) <- NULL

class(miranda_agrippino_ricco) <- c("mp_shock", "data.frame")
attr(miranda_agrippino_ricco, "series") <- "miranda_agrippino_ricco"
attr(miranda_agrippino_ricco, "frequency") <- "monthly"
attr(miranda_agrippino_ricco, "units") <- "percentage points"
attr(miranda_agrippino_ricco, "source_doi") <- "10.1257/mac.20180124"
attr(miranda_agrippino_ricco, "source_url") <- "https://github.com/riccardo-degasperi/info-policy-surprises"
attr(miranda_agrippino_ricco, "license") <- "Academic research data; cite Miranda-Agrippino and Ricco (2021)"
attr(miranda_agrippino_ricco, "downloaded") <- Sys.Date()

stopifnot(nrow(miranda_agrippino_ricco) > 100)

if (!dir.exists("data")) dir.create("data")
save(miranda_agrippino_ricco,
     file = "data/miranda_agrippino_ricco.rda",
     compress = "xz", version = 3)

message(sprintf(
  "miranda_agrippino_ricco: %d obs, %s to %s, shock range [%.4f, %.4f]",
  nrow(miranda_agrippino_ricco),
  format(min(miranda_agrippino_ricco$date)),
  format(max(miranda_agrippino_ricco$date)),
  min(miranda_agrippino_ricco$shock, na.rm = TRUE),
  max(miranda_agrippino_ricco$shock, na.rm = TRUE)
))
