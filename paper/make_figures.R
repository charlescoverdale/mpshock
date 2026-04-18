# Generate figures and tables for the mpshock working paper.
#
# Target aesthetic: working-paper / R Journal standard. That means:
#   * Serif typeface matching the paper body (Palatino, embedded reliably
#     via showtext so it actually renders, not just "specified")
#   * Legends OUTSIDE the plot area (below) so nothing overlaps
#   * Distinct, print-safe, colour-blind-friendly palette
#     (Okabe-Ito, widely adopted in Econometrica / QJE / R Journal)
#   * Subtle horizontal gridlines for y-axis readability
#   * No on-chart titles or subtitles (all info in the LaTeX caption)

suppressPackageStartupMessages({
  devtools::load_all(".", quiet = TRUE)
  library(ggplot2)
  library(showtext)
})

# Embed Helvetica Neue for the figures. R Journal uses Palatino (serif)
# in the body text but its figures typically use a sans-serif family to
# separate them visually. This follows the common QJE / AER convention
# too. The font is resolved via showtext so it embeds reliably in PDF.
font_add("HelveticaNeue",
         regular = "/System/Library/Fonts/Helvetica.ttc",
         bold = "/System/Library/Fonts/Helvetica.ttc",
         italic = "/System/Library/Fonts/Helvetica.ttc")
showtext_auto()
showtext_opts(dpi = 300)

fig_dir <- "paper/figures"
tab_dir <- "paper/tables"
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)
if (!dir.exists(tab_dir)) dir.create(tab_dir, recursive = TRUE)

# Okabe-Ito palette (colour-blind-friendly, print-safe, widely used in
# Econometrica / QJE / R Journal):
ok_blue   <- "#0072B2"
ok_orange <- "#E69F00"
ok_green  <- "#009E73"
ok_red    <- "#D55E00"
ok_purple <- "#CC79A7"
ok_yellow <- "#F0E442"
ok_sky    <- "#56B4E9"

fam <- "HelveticaNeue"

theme_wp <- function(base_size = 10) {
  theme_bw(base_size = base_size, base_family = fam) +
    theme(
      plot.title = element_blank(),
      plot.subtitle = element_blank(),
      plot.caption = element_blank(),
      panel.border = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(linewidth = 0.25, colour = "grey85"),
      axis.line = element_line(linewidth = 0.35, colour = "grey25"),
      axis.ticks = element_line(linewidth = 0.35, colour = "grey25"),
      axis.ticks.length = unit(2.5, "pt"),
      axis.text = element_text(size = base_size, colour = "grey20"),
      axis.title = element_text(size = base_size, colour = "grey20"),
      legend.position = "bottom",
      legend.title = element_blank(),
      legend.text = element_text(size = base_size - 1, family = fam),
      legend.key.height = unit(10, "pt"),
      legend.key.width = unit(22, "pt"),
      legend.spacing.x = unit(10, "pt"),
      legend.margin = margin(4, 0, 0, 0),
      plot.margin = margin(6, 10, 6, 6)
    )
}

theme_wp_hmap <- function(base_size = 10) {
  theme_minimal(base_size = base_size, base_family = fam) +
    theme(
      plot.title = element_blank(),
      plot.subtitle = element_blank(),
      panel.grid = element_blank(),
      axis.text = element_text(size = base_size, colour = "grey20",
                               family = fam),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      legend.position = "right",
      legend.title = element_text(size = base_size - 1, family = fam),
      legend.text = element_text(size = base_size - 2, family = fam),
      plot.margin = margin(6, 10, 6, 6)
    )
}

# ---- 1. Coverage timeline ----------------------------------------------------

meta <- mp_list()
meta$series <- factor(meta$series, levels = rev(meta$series))
meta$country_full <- factor(
  meta$country,
  levels = c("US", "UK", "AU"),
  labels = c("United States", "United Kingdom", "Australia")
)

p_coverage <- ggplot(meta, aes(y = series, colour = country_full)) +
  geom_segment(aes(x = start, xend = end, yend = series), linewidth = 2.4) +
  geom_point(aes(x = start), size = 1.5) +
  geom_point(aes(x = end),   size = 1.5) +
  scale_x_date(date_breaks = "10 years", date_labels = "%Y",
               limits = c(as.Date("1960-01-01"), as.Date("2026-06-01")),
               expand = c(0.01, 0)) +
  scale_colour_manual(values = c("United States"  = ok_blue,
                                 "United Kingdom" = ok_red,
                                 "Australia"      = ok_green)) +
  labs(x = NULL, y = NULL,
       title = NULL, subtitle = NULL) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "coverage_timeline.pdf"),
       p_coverage, width = 6.8, height = 4.2, device = cairo_pdf)

# ---- 2. US cross-series correlation heatmap ----------------------------------

us_series <- c("nakamura_steinsson", "bauer_swanson",
               "gss_target", "gss_path",
               "jarocinski_karadi_mp", "jarocinski_karadi_cbi",
               "miranda_agrippino_ricco")

starts <- sapply(us_series, function(s) as.character(min(mp_shock(s)$date)))
ends   <- sapply(us_series, function(s) as.character(max(mp_shock(s)$date)))
window_start <- max(as.Date(starts))
window_end   <- min(as.Date(ends))

panel <- data.frame(date = seq(window_start, window_end, by = "month"))
for (s in us_series) {
  d <- mp_shock(s, start = as.character(window_start),
                   end = as.character(window_end))
  panel[[s]] <- d$shock[match(panel$date, d$date)]
}

cor_mat <- cor(panel[, us_series], use = "pairwise.complete.obs")
cor_long <- as.data.frame(as.table(cor_mat))
names(cor_long) <- c("series_x", "series_y", "rho")

short_labels <- c(
  "nakamura_steinsson" = "NS",
  "bauer_swanson" = "BS",
  "gss_target" = "GSS-T",
  "gss_path" = "GSS-P",
  "jarocinski_karadi_mp" = "JK-MP",
  "jarocinski_karadi_cbi" = "JK-CBI",
  "miranda_agrippino_ricco" = "MAR"
)
cor_long$series_x <- factor(short_labels[as.character(cor_long$series_x)],
                            levels = short_labels)
cor_long$series_y <- factor(short_labels[as.character(cor_long$series_y)],
                            levels = short_labels)

p_cor <- ggplot(cor_long, aes(series_x, series_y, fill = rho)) +
  geom_tile(colour = "white", linewidth = 0.4) +
  geom_text(aes(label = sprintf("%.2f", rho),
                colour = abs(rho) > 0.55),
            size = 3.2, family = fam) +
  scale_fill_gradient2(low = ok_red, mid = "grey97", high = ok_blue,
                       midpoint = 0, limits = c(-1, 1),
                       breaks = c(-1, -0.5, 0, 0.5, 1)) +
  scale_colour_manual(values = c(`TRUE` = "white", `FALSE` = "grey20"),
                      guide = "none") +
  coord_fixed() +
  labs(fill = expression(rho),
       title = NULL, subtitle = NULL) +
  theme_wp_hmap(base_size = 10)

ggsave(file.path(fig_dir, "us_correlations.pdf"),
       p_cor, width = 5.6, height = 4.4, device = cairo_pdf)

# ---- 3. Cumulative US shocks -------------------------------------------------

cum_df <- do.call(rbind, lapply(
  c("nakamura_steinsson", "bauer_swanson",
    "jarocinski_karadi_mp", "miranda_agrippino_ricco"),
  function(s) {
    d <- mp_shock(s, start = as.character(window_start),
                     end = as.character(window_end))
    d$shock[is.na(d$shock)] <- 0
    data.frame(date = d$date, series = s, shock_cum = cumsum(d$shock))
  }
))
cum_df$series <- factor(cum_df$series,
  levels = c("nakamura_steinsson", "bauer_swanson",
             "jarocinski_karadi_mp", "miranda_agrippino_ricco"),
  labels = c("Nakamura-Steinsson (2018)",
             "Bauer-Swanson (2023, MPS_ORTH)",
             "Jarocinski-Karadi (2020, pure MP)",
             "Miranda-Agrippino-Ricco (2021)"))

p_cum <- ggplot(cum_df, aes(date, shock_cum, colour = series,
                            linetype = series)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
  geom_line(linewidth = 0.7) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y",
               expand = expansion(add = c(30, 30))) +
  scale_colour_manual(values = c(ok_blue, ok_red, ok_green, ok_orange)) +
  scale_linetype_manual(values = c("solid", "longdash", "dotted", "dotdash")) +
  labs(x = NULL, y = "Cumulative shock (percentage points)",
       title = NULL, subtitle = NULL) +
  guides(colour = guide_legend(nrow = 2), linetype = guide_legend(nrow = 2)) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "cumulative_us.pdf"),
       p_cum, width = 6.8, height = 4.6, device = cairo_pdf)

# ---- 4. Cross-country cumulative shocks --------------------------------------

cross_country <- rbind(
  local({
    d <- mp_shock("bauer_swanson", start = "2005-01-01", end = "2022-12-31")
    d$shock[is.na(d$shock)] <- 0
    data.frame(date = d$date, country = "United States",
               shock_cum = cumsum(d$shock))
  }),
  local({
    d <- mp_shock("ukmpd", start = "2005-01-01", end = "2022-12-31")
    d$shock[is.na(d$shock)] <- 0
    data.frame(date = d$date, country = "United Kingdom",
               shock_cum = cumsum(d$shock))
  }),
  local({
    d <- mp_shock("hambur_haque_au", start = "2005-01-01", end = "2022-12-31")
    d$shock[is.na(d$shock)] <- 0
    data.frame(date = d$date, country = "Australia",
               shock_cum = cumsum(d$shock))
  })
)
cross_country$country <- factor(cross_country$country,
  levels = c("United States", "United Kingdom", "Australia"))

y_top <- max(cross_country$shock_cum)

p_cross <- ggplot(cross_country, aes(date, shock_cum,
                                     colour = country, linetype = country)) +
  annotate("rect", xmin = as.Date("2008-09-01"), xmax = as.Date("2009-06-01"),
           ymin = -Inf, ymax = Inf, alpha = 0.10, fill = "grey50") +
  annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2020-06-01"),
           ymin = -Inf, ymax = Inf, alpha = 0.10, fill = "grey50") +
  annotate("text", x = as.Date("2009-01-15"), y = y_top * 0.95,
           label = "GFC", size = 2.9, family = fam,
           colour = "grey35", fontface = "italic") +
  annotate("text", x = as.Date("2020-04-15"), y = y_top * 0.95,
           label = "COVID-19", size = 2.9, family = fam,
           colour = "grey35", fontface = "italic") +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
  geom_line(linewidth = 0.75) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y",
               expand = expansion(add = c(30, 30))) +
  scale_colour_manual(values = c("United States"  = ok_blue,
                                 "United Kingdom" = ok_red,
                                 "Australia"      = ok_green)) +
  scale_linetype_manual(values = c("United States"  = "solid",
                                   "United Kingdom" = "longdash",
                                   "Australia"      = "dotted")) +
  labs(x = NULL, y = "Cumulative shock (percentage points)",
       title = NULL, subtitle = NULL) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "cross_country.pdf"),
       p_cross, width = 7.0, height = 4.6, device = cairo_pdf)

# ---- 5. Distribution of nonzero shocks ---------------------------------------

short_for_plot <- c(short_labels,
  "ukmpd" = "UKMPD",
  "cesa_bianchi_uk" = "CTV",
  "hambur_haque_au" = "HH")
dist_df <- do.call(rbind, lapply(
  c("nakamura_steinsson", "bauer_swanson",
    "jarocinski_karadi_mp", "miranda_agrippino_ricco",
    "ukmpd", "cesa_bianchi_uk", "hambur_haque_au"),
  function(s) {
    d <- mp_shock(s)
    x <- d$shock[!is.na(d$shock) & d$shock != 0]
    data.frame(series = short_for_plot[s], shock = x,
               country = meta$country[meta$series == s])
  }
))
dist_df$series <- factor(dist_df$series,
  levels = c("NS", "BS", "JK-MP", "MAR", "UKMPD", "CTV", "HH"))
dist_df$country <- factor(dist_df$country,
  levels = c("US", "UK", "AU"),
  labels = c("United States", "United Kingdom", "Australia"))

p_dist <- ggplot(dist_df, aes(x = series, y = shock, colour = country)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
  geom_jitter(width = 0.18, alpha = 0.35, size = 0.45) +
  geom_boxplot(fill = NA, outlier.shape = NA, linewidth = 0.35,
               colour = "grey20", width = 0.45) +
  scale_colour_manual(values = c("United States"  = ok_blue,
                                 "United Kingdom" = ok_red,
                                 "Australia"      = ok_green)) +
  labs(x = NULL, y = "Shock value (percentage points)",
       title = NULL, subtitle = NULL) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "distribution.pdf"),
       p_dist, width = 6.8, height = 4.4, device = cairo_pdf)

# ---- LaTeX tables ------------------------------------------------------------

tex_esc <- function(x) gsub("_", "\\\\_", as.character(x))

# Correlation table (lower triangle)
tex_tab <- capture.output({
  cat("\\begin{tabular}{l", paste(rep("c", length(us_series)), collapse = ""),
      "}\n", sep = "")
  cat("\\toprule\n")
  cat("& ", paste0("(", seq_along(us_series), ")", collapse = " & "), " \\\\\n")
  cat("\\midrule\n")
  for (i in seq_along(us_series)) {
    cells <- sapply(seq_along(us_series), function(j) {
      if (j > i) "" else sprintf("%.2f", cor_mat[i, j])
    })
    cat(sprintf("(%d) \\texttt{%s} & %s \\\\\n", i,
                tex_esc(us_series[i]),
                paste(cells, collapse = " & ")))
  }
  cat("\\bottomrule\n")
  cat("\\end{tabular}\n")
})
writeLines(tex_tab, file.path(tab_dir, "us_correlations.tex"))

# Series summary: longtable with explicit column widths sized to fit the
# A4 text width. The crucial fix is that the Series column must be
# BOUNDED (p{width}) rather than `l`, because `miranda_agrippino_ricco`
# in texttt alone takes ~4.2cm at footnotesize; an unbounded column lets
# that push the rest of the table off the page. The widths below sum
# to ~14.7cm, which fits comfortably inside the 16cm A4 text block with
# room for the default \tabcolsep.
summary_tab <- capture.output({
  cat("{\\small\n")
  cat("\\setlength{\\tabcolsep}{4pt}\n")
  cat("\\renewcommand{\\arraystretch}{1.15}\n")
  cat("\\begin{longtable}{@{}>{\\ttfamily\\scriptsize}p{3.8cm} p{4.6cm} c c c l@{}}\n")
  cat("\\toprule\n")
  cat("\\multicolumn{1}{l}{\\normalsize\\textnormal{Series}} & Author(s) & Country & Freq. & Type & Span \\\\\n")
  cat("\\midrule\n")
  cat("\\endfirsthead\n")
  cat("\\toprule\n")
  cat("\\multicolumn{1}{l}{\\normalsize\\textnormal{Series}} & Author(s) & Country & Freq. & Type & Span \\\\\n")
  cat("\\midrule\n")
  cat("\\endhead\n")
  cat("\\midrule\n")
  cat("\\multicolumn{6}{r}{\\textit{(continued on next page)}} \\\\\n")
  cat("\\endfoot\n")
  cat("\\bottomrule\n")
  cat("\\endlastfoot\n")
  for (i in seq_len(nrow(meta))) {
    r <- meta[i, ]
    cat(sprintf("%s & %s & %s & %s & %s & %s--%s \\\\\n",
                tex_esc(r$series),
                tex_esc(r$author),
                tex_esc(r$country),
                tex_esc(r$frequency),
                tex_esc(r$type),
                format(as.Date(r$start), "%Y-%m"),
                format(as.Date(r$end),   "%Y-%m")))
  }
  cat("\\end{longtable}\n")
  cat("}\n")
})
writeLines(summary_tab, file.path(tab_dir, "series_summary.tex"))

cat("\n--- done ---\n")
