# CRAN submission comments: mpshock 0.1.2

## Resubmission

This is a resubmission. The Federal Reserve Bank of Atlanta moved its
Wu-Xia shadow rate page, so the link in `man/wu_xia.Rd` returned 404.
It now points to the page's current address
(<https://www.atlantafed.org/research-and-data/data/wu-xia-shadow-federal-funds-rate>),
checked with `urlchecker::url_check()`.

## Reason for this submission

Data refresh. Two bundled series are extended with their authors'
latest published updates (the Jarocinski-Karadi shocks to September
2026, the Bank of England UK Monetary Policy Event-Study Database to
April 2026). No code changes.

## R CMD check results

0 errors | 0 warnings | 0 notes (CRAN settings, R 4.5.2, macOS).

## Downstream dependencies

None on CRAN.
