# make_slide_figures.R (mpshock)
# Prepare slide-ready figures:
#  1. Copy the paper's cross-country PDF as the hero figure
#  2. Copy four gallery figures (cumulative_us, us_correlations,
#     coverage_timeline, distribution) under slide-ready names
#  3. Generate a QR code pointing to the paper PDF
#
# Usage:  Rscript make_slide_figures.R

suppressPackageStartupMessages({
  if (!requireNamespace("qrcode", quietly = TRUE)) {
    install.packages("qrcode", repos = "https://cloud.r-project.org")
  }
  library(qrcode)
})

fig_dir <- "figures"
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)

paper_figs <- file.path("..", "figures")

# ------------------------------------------------------------------
# 1. Hero figure: cross-country cumulative shocks (US, UK, AU)
# ------------------------------------------------------------------
src <- file.path(paper_figs, "cross_country.pdf")
dst <- file.path(fig_dir, "hero_figure.pdf")

if (file.exists(src)) {
  file.copy(src, dst, overwrite = TRUE)
  cat("Copied hero figure to", dst, "\n")
} else {
  stop("Source figure not found: ", src,
       ". Run the paper's make_figures.R first.")
}

# ------------------------------------------------------------------
# 2. Gallery + deep-dive figures
# ------------------------------------------------------------------
copies <- list(
  c("cumulative_us.pdf",    "fig1_cumulative_us.pdf"),
  c("us_correlations.pdf",  "fig2_correlations.pdf"),
  c("coverage_timeline.pdf","fig3_coverage.pdf"),
  c("distribution.pdf",     "fig4_distribution.pdf")
)

for (pair in copies) {
  s <- file.path(paper_figs, pair[1])
  d <- file.path(fig_dir,    pair[2])
  if (!file.exists(s)) {
    stop("Source figure not found: ", s)
  }
  file.copy(s, d, overwrite = TRUE)
  cat("Copied", s, "->", d, "\n")
}

# ------------------------------------------------------------------
# 3. QR code to the paper PDF on the publications page
# ------------------------------------------------------------------
paper_url <- "https://charlescoverdale.github.io/files/coverdale_mpshock_2026.pdf"

qr <- qr_code(paper_url, ecl = "M")
png(
  filename = file.path(fig_dir, "qrcode_paper.png"),
  width = 800, height = 800, res = 300, bg = "white"
)
par(mar = rep(0, 4))
plot(qr)
dev.off()

cat("QR code written to", file.path(fig_dir, "qrcode_paper.png"), "\n")
