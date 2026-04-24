# Jarocinski-Karadi pure monetary policy shock

The "pure" monetary policy shock from Jarocinski and Karadi (2020),
identified via sign restrictions on the joint response of short-term
interest rates and stock prices around FOMC announcements. The median
decomposition allows the MP and information shocks to co-occur. Monthly
US series from the authors' maintained update.

## Usage

``` r
jarocinski_karadi_mp
```

## Format

A data frame with columns:

- date:

  `Date`. First day of the observation month.

- shock:

  `numeric`. Pure MP shock (MP_median), percentage points.

- series:

  `character`. Series identifier `"jarocinski_karadi_mp"`.

## Source

Jarocinski, M., & Karadi, P. (2020). "Deconstructing Monetary Policy
Surprises: The Role of Information Shocks." *American Economic Journal:
Macroeconomics* 12(2): 1-43.
[doi:10.1257/mac.20180090](https://doi.org/10.1257/mac.20180090) .
Updated data:
<https://github.com/marekjarocinski/jkshocks_update_fed_202401>.

## Details

**Identification.** Two high-frequency surprises enter: the 3-month
fed-funds futures and the S&P 500, both in 30-minute windows around FOMC
announcements. A 2-shock SVAR is identified by sign restrictions: a
positive MP shock raises rates and lowers stocks (negative co-movement);
a positive CB-information shock raises both (positive co-movement).

**Median vs poor-man's decomposition.** The "poor-man's" variant sorts
events by sign pattern and assigns each surprise wholly to one shock.
The median variant solves the set-identified problem and picks the
rotation whose impulse responses lie at the median of admissible
rotations; both shocks can co-occur at every event. `mpshock` uses the
median version (`MP_median`, `CBI_median`). Results are set-identified,
not point-identified: users should report robustness across rotations.

**Critical follow-up.** Acosta (2023, "Perceived Causes of Monetary
Policy Surprises") argues that the rate-stock sign pattern is a weak
discriminator between policy and information shocks because the two are
typically negatively correlated at high frequency regardless of shock
type. Bauer and Swanson (2023) argue the information shock reflects
omitted pre-announcement data rather than genuine Fed private
information. Users estimating information-effect IRFs should report
robustness to these critiques.
