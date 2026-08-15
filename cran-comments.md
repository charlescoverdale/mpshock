# CRAN submission comments — mpshock 0.1.1

## Reason for this submission

This is an update to mpshock 0.1.0, currently on CRAN. It corrects a
source attribution error in the bundled data documentation.

The `bauer_swanson` series is MPS_ORTH, the orthogonalised monetary
policy surprise. That construction comes from Bauer and Swanson, "A
Reassessment of Monetary Policy Surprises and High-Frequency
Identification", NBER Macroeconomics Annual 37:87-155 (2023), DOI
10.1086/723574. The package previously cited the same authors' other
2023 paper, "An Alternative Explanation for the 'Fed Information
Effect'" (American Economic Review 113(3):664-700, DOI
10.1257/aer.20201220), which concerns the Fed-information-effect debate
rather than the MPS_ORTH construction.

Since this is a data package whose value rests on correct provenance,
the wrong citation is the kind of defect worth a release on its own. The
correction is applied to `DESCRIPTION`, `inst/CITATION`, the series
documentation, the metadata returned by `mp_series()`, and the README
citation table. The AER paper remains cited where it is genuinely the
right reference, in the discussion of the information-effect critique.

The data itself is unchanged. No API changes.

## Also in this release

A URL-verification test covering the bundled DOIs, to catch this class
of regression, and the pkgdown site advertised in `DESCRIPTION`.

## R CMD check results

0 errors | 0 warnings | 0 notes (CRAN default settings, R 4.5.2, macOS).

## Downstream dependencies

None on CRAN.
