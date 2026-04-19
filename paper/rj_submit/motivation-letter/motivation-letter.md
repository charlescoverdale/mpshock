---
output: pdf_document
fontsize: 12pt
---

\thispagestyle{empty}
\today

The Editor
The R Journal
\bigskip

Dear Editor,
\bigskip

Please consider the article *Mpshock: An R Package for Cross-Country Monetary Policy Shock Analysis* for publication in the R Journal.

The mpshock package bundles thirteen identified monetary policy shock and stance series from the empirical macroeconomics literature across three countries (United States, United Kingdom, Australia) as tidy, versioned, and tested data frames with full provenance metadata. No existing R package assembles shock series for more than one jurisdiction. The gap matters because robustness checks across several identification strategies, and increasingly across central banks, are now standard practice in applied monetary economics, yet the raw inputs remain scattered across individual authors' personal pages, Federal Reserve research data archives, and GitHub mirrors with inconsistent column names, date formats, and update cadences. The package collapses this assembly cost from hours to one function call per series.

The R Journal's readers in applied macroeconomics, central-bank research departments, and graduate programmes that teach empirical monetary economics can use the package to reduce their own data-preparation overhead, to replicate cross-series comparisons from the identification literature, and to extend local-projection and SVAR analyses across countries from a single clean pipeline. The helpers `mp_align`, `mp_to_quarterly`, and `mp_cumulate` plug directly into the standard downstream packages for impulse response estimation (lpirfs, BVAR, vars).

The manuscript has not been published in a peer-reviewed journal, is not currently under review elsewhere, and all rights to submit rest with the sole author.

\bigskip
\bigskip

Regards,
\bigskip
\bigskip

Charles Coverdale
London, United Kingdom
charles.f.coverdale@gmail.com
