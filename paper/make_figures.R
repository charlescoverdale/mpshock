# Generate figures and tables for the mpshock working paper.
#
# Running this script writes:
#   paper/figures/coverage_timeline.pdf    — Gantt-style series coverage chart
#   paper/figures/us_correlations.pdf      — US cross-series correlation heatmap
#   paper/figures/cumulative_us.pdf        — Cumulative US shocks over common window
#   paper/figures/cross_country.pdf        — US vs UK vs AU cumulative shock comparison
#   paper/figures/distribution.pdf         — Distribution of absolute shocks by series
#   paper/tables/us_correlations.tex       — LaTeX-ready correlation table
#   paper/tables/series_summary.tex        — LaTeX-ready series summary table
#
# All figures save as PDFs at the native publication aspect ratio.

suppressPackageStartupMessages({
  devtools::load_all(".", quiet = TRUE)
  library(ggplot2)
})

fig_dir <- "paper/figures"
tab_dir <- "paper/tables"
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)
if (!dir.exists(tab_dir)) dir.create(tab_dir, recursive = TRUE)

theme_paper <- function() {
  theme_minimal(base_size = 10, base_family = "") +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.2, colour = "grey85"),
      axis.line = element_line(linewidth = 0.3),
      plot.title = element_text(size = 11, face = "bold"),
      plot.subtitle = element_text(size = 9, colour = "grey40"),
      legend.title = element_text(size = 9),
      legend.text = element_text(size = 8),
      strip.text = element_text(size = 9, face = "bold")
    )
}

# ---- Coverage timeline -------------------------------------------------------

meta <- mp_list()
meta$series <- factor(meta$series, levels = rev(meta$series))
meta$country_full <- factor(
  meta$country,
  levels = c("US", "UK", "AU"),
  labels = c("United States", "United Kingdom", "Australia")
)

p_coverage <- ggplot(meta, aes(y = series, colour = country_full)) +
  geom_segment(aes(x = start, xend = end, yend = series), linewidth = 2) +
  geom_point(aes(x = start), size = 1.2) +
  geom_point(aes(x = end),   size = 1.2) +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") +
  scale_colour_manual(values = c("United States" = "#1f4e79",
                                 "United Kingdom" = "#c00000",
                                 "Australia" = "#2f7d2f")) +
  labs(
    x = NULL, y = NULL, colour = "Country",
    title = "Coverage span of the thirteen bundled shock and stance series"
  ) +
  theme_paper() +
  theme(legend.position = "top")

ggsave(file.path(fig_dir, "coverage_timeline.pdf"),
       p_coverage, width = 7, height = 4.2)

# ---- US cross-series correlation ---------------------------------------------

us_series <- c("nakamura_steinsson", "bauer_swanson",
               "gss_target", "gss_path",
               "jarocinski_karadi_mp", "jarocinski_karadi_cbi",
               "miranda_agrippino_ricco")

# Common window: max of starts, min of ends
starts <- sapply(us_series, function(s) as.character(min(mp_shock(s)$date)))
ends   <- sapply(us_series, function(s) as.character(max(mp_shock(s)$date)))
window_start <- max(as.Date(starts))
window_end   <- min(as.Date(ends))
cat(sprintf("US common window: %s to %s\n", window_start, window_end))

# Wide panel
panel <- data.frame(date = seq(window_start, window_end, by = "month"))
for (s in us_series) {
  d <- mp_shock(s, start = as.character(window_start),
                   end = as.character(window_end))
  panel[[s]] <- d$shock[match(panel$date, d$date)]
}

cor_mat <- cor(panel[, us_series], use = "pairwise.complete.obs")
cor_long <- as.data.frame(as.table(cor_mat))
names(cor_long) <- c("series_x", "series_y", "rho")

p_cor <- ggplot(cor_long, aes(series_x, series_y, fill = rho)) +
  geom_tile() +
  geom_text(aes(label = sprintf("%.2f", rho)), size = 2.8, colour = "white") +
  scale_fill_gradient2(low = "#c00000", mid = "grey90", high = "#1f4e79",
                       midpoint = 0, limits = c(-1, 1)) +
  labs(x = NULL, y = NULL, fill = expression(rho),
       title = "Pairwise correlations, US monetary policy shock series",
       subtitle = sprintf("Common monthly sample: %s to %s (%d observations)",
                          window_start, window_end, nrow(panel))) +
  theme_paper() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank())

ggsave(file.path(fig_dir, "us_correlations.pdf"),
       p_cor, width = 6.5, height = 5.5)

# Write LaTeX correlation table (booktabs)
tex_tab <- capture.output({
  cat("\\begin{tabular}{l", paste(rep("c", length(us_series)), collapse = ""),
      "}\n", sep = "")
  cat("\\toprule\n")
  cat("& ", paste0(seq_along(us_series), collapse = " & "), " \\\\\n")
  cat("\\midrule\n")
  for (i in seq_along(us_series)) {
    cells <- sapply(seq_along(us_series), function(j) {
      if (j < i) "" else sprintf("%.2f", cor_mat[i, j])
    })
    cat(sprintf("(%d) %s & %s \\\\\n", i,
                gsub("_", "\\\\_", us_series[i]),
                paste(cells, collapse = " & ")))
  }
  cat("\\bottomrule\n")
  cat("\\end{tabular}\n")
})
writeLines(tex_tab, file.path(tab_dir, "us_correlations.tex"))

# ---- Cumulative US shocks ----------------------------------------------------

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
cum_df$series <- factor(cum_df$series, levels = c(
  "nakamura_steinsson", "bauer_swanson",
  "jarocinski_karadi_mp", "miranda_agrippino_ricco"))

p_cum <- ggplot(cum_df, aes(date, shock_cum, colour = series)) +
  geom_line(linewidth = 0.7) +
  scale_colour_manual(values = c(
    "nakamura_steinsson"     = "#1f4e79",
    "bauer_swanson"          = "#c00000",
    "jarocinski_karadi_mp"   = "#2f7d2f",
    "miranda_agrippino_ricco" = "#7a4c9e"),
    labels = c(
      "nakamura_steinsson"     = "Nakamura-Steinsson (2018)",
      "bauer_swanson"          = "Bauer-Swanson (2023, MPS_ORTH)",
      "jarocinski_karadi_mp"   = "Jarocinski-Karadi (2020, pure MP)",
      "miranda_agrippino_ricco" = "Miranda-Agrippino-Ricco (2021)")) +
  labs(x = NULL, y = "Cumulative monetary policy shock (pp)",
       colour = NULL,
       title = "Cumulative US monetary policy shocks: four identification strategies",
       subtitle = sprintf("Common sample: %s to %s", window_start, window_end)) +
  theme_paper() +
  theme(legend.position = "top")

ggsave(file.path(fig_dir, "cumulative_us.pdf"),
       p_cum, width = 7, height = 4.5)

# ---- Cross-country cumulative shocks -----------------------------------------

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

p_cross <- ggplot(cross_country, aes(date, shock_cum, colour = country)) +
  geom_line(linewidth = 0.7) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
  scale_colour_manual(values = c("United States" = "#1f4e79",
                                 "United Kingdom" = "#c00000",
                                 "Australia" = "#2f7d2f")) +
  annotate("rect",
           xmin = as.Date("2008-09-01"), xmax = as.Date("2009-06-01"),
           ymin = -Inf, ymax = Inf, alpha = 0.08, fill = "grey50") +
  annotate("rect",
           xmin = as.Date("2020-03-01"), xmax = as.Date("2020-06-01"),
           ymin = -Inf, ymax = Inf, alpha = 0.08, fill = "grey50") +
  labs(x = NULL, y = "Cumulative monetary policy shock (pp)",
       colour = NULL,
       title = "Cross-country cumulative monetary policy shocks, 2005--2022",
       subtitle = "Bauer-Swanson (US, MPS_ORTH), UKMPD (UK, Target factor), Hambur-Haque (AU, action factor)") +
  theme_paper() +
  theme(legend.position = "top")

ggsave(file.path(fig_dir, "cross_country.pdf"),
       p_cross, width = 7.2, height = 4.5)

# ---- Shock distribution ------------------------------------------------------

dist_df <- do.call(rbind, lapply(
  c("nakamura_steinsson", "bauer_swanson",
    "jarocinski_karadi_mp", "miranda_agrippino_ricco",
    "ukmpd", "cesa_bianchi_uk", "hambur_haque_au"),
  function(s) {
    d <- mp_shock(s)
    data.frame(series = s, shock = d$shock[!is.na(d$shock) & d$shock != 0])
  }
))

p_dist <- ggplot(dist_df, aes(x = series, y = shock)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
  geom_jitter(width = 0.2, alpha = 0.25, size = 0.4, colour = "#1f4e79") +
  geom_boxplot(fill = NA, outlier.shape = NA, linewidth = 0.3, colour = "black") +
  labs(x = NULL, y = "Shock value (percentage points)",
       title = "Distribution of nonzero monetary policy shocks",
       subtitle = "Each point is a nonzero monthly observation") +
  theme_paper() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(fig_dir, "distribution.pdf"),
       p_dist, width = 7.2, height = 4.5)

# ---- Series summary table (LaTeX) --------------------------------------------

tex_esc <- function(x) gsub("_", "\\\\_", as.character(x))

summary_tab <- capture.output({
  cat("\\begin{tabular}{llllll}\n")
  cat("\\toprule\n")
  cat("Series & Author(s) & Country & Freq. & Type & Span \\\\\n")
  cat("\\midrule\n")
  for (i in seq_len(nrow(meta))) {
    r <- meta[i, ]
    cat(sprintf("\\texttt{%s} & %s & %s & %s & %s & %s--%s \\\\\n",
                tex_esc(r$series),
                tex_esc(r$author),
                tex_esc(r$country),
                tex_esc(r$frequency),
                tex_esc(r$type),
                format(as.Date(r$start), "%Y-%m"),
                format(as.Date(r$end),   "%Y-%m")))
  }
  cat("\\bottomrule\n")
  cat("\\end{tabular}\n")
})
writeLines(summary_tab, file.path(tab_dir, "series_summary.tex"))

cat("\n--- done ---\n")
