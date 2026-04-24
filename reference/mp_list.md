# List available monetary policy shock series

Returns a metadata table of every shock or stance series bundled in the
package.

## Usage

``` r
mp_list()
```

## Value

A data frame with one row per series and columns:

- `series`: identifier used with
  [`mp_shock()`](https://charlescoverdale.github.io/mpshock/reference/mp_shock.md).

- `author`: short author string, e.g. "Nakamura and Steinsson (2018)".

- `country`: ISO country code or "EA" for Euro area.

- `frequency`: `"monthly"`, `"quarterly"`, or `"event"`.

- `type`: `"shock"` for identified monetary policy shocks,
  `"shadow_rate"` for shadow-rate stance measures, `"surprise"` for
  high-frequency event-window surprises.

- `start`, `end`: coverage span as `Date` (first and last bundled
  observation).

- `n`: number of non-missing shock observations.

- `doi`: DOI of the source paper.

- `source_url`: canonical URL for the published series.

- `description`: short prose description.

## Examples

``` r
mp_list()
#>                     series                                           author
#> 1       nakamura_steinsson                    Nakamura and Steinsson (2018)
#> 2            bauer_swanson                         Bauer and Swanson (2023)
#> 3               gss_target Gurkaynak, Sack, Swanson (2005) / Swanson (2021)
#> 4                 gss_path Gurkaynak, Sack, Swanson (2005) / Swanson (2021)
#> 5     jarocinski_karadi_mp                     Jarocinski and Karadi (2020)
#> 6    jarocinski_karadi_cbi                     Jarocinski and Karadi (2020)
#> 7  miranda_agrippino_ricco               Miranda-Agrippino and Ricco (2021)
#> 8                   wu_xia                                Wu and Xia (2016)
#> 9                    ukmpd            Braun, Miranda-Agrippino, Saha (2025)
#> 10         cesa_bianchi_uk          Cesa-Bianchi, Thwaites, Vicondoa (2020)
#> 11       cloyne_hurtgen_uk                        Cloyne and Hurtgen (2016)
#> 12         hambur_haque_au                          Hambur and Haque (2023)
#> 13              beckers_au                                   Beckers (2020)
#>    country frequency        type      start        end   n
#> 1       US   monthly       shock 2000-02-01 2014-03-01 170
#> 2       US   monthly       shock 1988-02-01 2023-12-01 431
#> 3       US   monthly       shock 1991-07-01 2015-10-01 292
#> 4       US   monthly       shock 1991-07-01 2015-10-01 292
#> 5       US   monthly       shock 1990-02-01 2024-01-01 404
#> 6       US   monthly information 1990-02-01 2024-01-01 404
#> 7       US   monthly       shock 1991-01-01 2019-06-01 342
#> 8       US   monthly shadow_rate 1960-01-01 2022-02-01 385
#> 9       UK   monthly       shock 1997-06-01 2026-02-01 345
#> 10      UK   monthly       shock 1997-06-01 2015-01-01 212
#> 11      UK   monthly   narrative 1997-06-01 2009-02-01 141
#> 12      AU   monthly       shock 2001-04-01 2019-12-01 225
#> 13      AU quarterly   narrative 1994-03-01 2018-11-01 100
#>                                 doi
#> 1                10.1093/qje/qjy004
#> 2                    10.1086/723574
#> 3     10.1016/j.jmoneco.2020.09.003
#> 4     10.1016/j.jmoneco.2020.09.003
#> 5              10.1257/mac.20180090
#> 6              10.1257/mac.20180090
#> 7              10.1257/mac.20180124
#> 8                10.1111/jmcb.12300
#> 9     10.1016/j.jmoneco.2024.103645
#> 10 10.1016/j.euroecorev.2020.103375
#> 11             10.1257/mac.20150093
#> 12          10.1111/1475-4932.12786
#> 13                                 
#>                                                                                      source_url
#> 1               https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HZOXKN
#> 2    https://www.frbsf.org/research-and-insights/data-and-indicators/monetary-policy-surprises/
#> 3                                                       https://sites.socsci.uci.edu/~swanson2/
#> 4                                                       https://sites.socsci.uci.edu/~swanson2/
#> 5                                 https://github.com/marekjarocinski/jkshocks_update_fed_202401
#> 6                                 https://github.com/marekjarocinski/jkshocks_update_fed_202401
#> 7                                   https://github.com/riccardo-degasperi/info-policy-surprises
#> 8                     https://www.atlantafed.org/cqer/research/wu-xia-shadow-federal-funds-rate
#> 9  https://www.bankofengland.co.uk/working-paper/2023/measuring-monetary-policy-in-the-uk-ukmpd
#> 10                                           https://sites.google.com/site/ambropo/publications
#> 11                           https://www.openicpsr.org/openicpsr/project/114114/version/V1/view
#> 12                                        https://www.rba.gov.au/publications/rdp/2023/2023-04/
#> 13                                        https://www.rba.gov.au/publications/rdp/2020/2020-01/
#>                                                                                                                                                                                         description
#> 1                                      Policy news shock: first principal component of five interest-rate futures surprises in a 30-minute window around FOMC announcements, aggregated to monthly.
#> 2                                                          Orthogonalised monetary policy surprise (MPS_ORTH): high-frequency FOMC-event surprise purged of predictability from public information.
#> 3                                            Federal Funds Rate factor (extended): the Swanson (2021) three-factor decomposition analogue of the original GSS target factor, aggregated to monthly.
#> 4                                                Forward Guidance factor (extended): the Swanson (2021) three-factor decomposition analogue of the original GSS path factor, aggregated to monthly.
#> 5                                                 Pure monetary policy shock (median decomposition): high-frequency FOMC surprise identified by sign restrictions on the joint rate-stock response.
#> 6                                                          Central bank information shock (median decomposition): the component of FOMC surprises co-moving rates and stocks in the same direction.
#> 7                                                             Informationally-robust monetary policy shock: FF4 high-frequency surprise orthogonalised against the Fed's Greenbook information set.
#> 8                                 Shadow federal funds rate: the Wu-Xia estimate of what the fed funds rate would have been during zero-lower-bound episodes. Shock column is the first difference.
#> 9  UK Monetary Policy Event-Study Database (UKMPD): three-factor decomposition (Target, Path, QE) of high-frequency surprises around Bank of England MPC announcements. Live-maintained by the BoE.
#> 10                                                 UK high-frequency monetary policy surprise: Kuttner-style tight-window surprise around Bank of England MPC announcements, aggregated to monthly.
#> 11                            UK narrative monetary policy shock: Romer-Romer-style identification using Bank of England Inflation Report forecasts to purge the cash rate of systematic reactions.
#> 12                                       Australian monetary policy surprise: three-component decomposition (action, path, term premium) of OIS and AGS yield moves around RBA cash-rate decisions.
#> 13     Australian narrative monetary policy shock: cash-rate changes orthogonal to RBA internal forecasts, augmented with credit-spread information (Beckers's 'BT-CS' headline series), quarterly.
```
