# Jarocinski-Karadi central bank information shock

The "central bank information" shock from Jarocinski and Karadi (2020),
identified alongside the pure MP shock by sign restrictions on the joint
rate-stock response. The information shock moves short rates and stock
prices in the same direction, interpreted as the central bank revealing
private information about the economy. Monthly US series from the
authors' maintained update.

## Usage

``` r
jarocinski_karadi_cbi
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. CB information shock (CBI_median), percentage points.

- series:

  `character`. Series identifier `"jarocinski_karadi_cbi"`.

## Source

Jarocinski, M., & Karadi, P. (2020). "Deconstructing Monetary Policy
Surprises: The Role of Information Shocks." *American Economic Journal:
Macroeconomics* 12(2): 1-43.
[doi:10.1257/mac.20180090](https://doi.org/10.1257/mac.20180090) .
Updated data:
<https://github.com/marekjarocinski/jkshocks_update_fed_202401>.

## Details

See
[jarocinski_karadi_mp](https://charlescoverdale.github.io/mpshock/reference/jarocinski_karadi_mp.md)
for the full identification scheme and caveats. The information shock is
the companion component: if markets interpret a hawkish rate surprise as
a sign the Fed has seen positive economic news, stocks rise rather than
fall.

**Controversy.** Bauer-Swanson (2023) and Acosta (2023) argue the
information shock is largely artefactual: an omitted-variables problem
(Fed and markets reacting to the same pre-meeting public data) plus a
weak sign-restriction identifier. Interpret with caution; if the
information-effect literature is central to your result, read both
critiques before citing.
