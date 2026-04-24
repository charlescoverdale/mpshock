# Print an mp_shock object

Prints a short provenance header followed by the first rows of the shock
series.

## Usage

``` r
# S3 method for class 'mp_shock'
print(x, n = 10L, ...)
```

## Arguments

- x:

  An `mp_shock` object.

- n:

  Integer, number of rows to print. Default 10.

- ...:

  Ignored.

## Value

`x`, invisibly.

## Examples

``` r
print(mp_shock("nakamura_steinsson"))
#> <mp_shock> nakamura_steinsson [monthly, 170 obs, 2000-02-01 to 2014-03-01]
#>        date      shock
#>  2000-02-01  0.0215744
#>  2000-03-01 -0.0028683
#>  2000-04-01  0.0000000
#>  2000-05-01  0.0335943
#>  2000-06-01 -0.0061341
#>  2000-07-01  0.0000000
#>  2000-08-01  0.0126884
#>  2000-09-01  0.0000000
#>  2000-10-01  0.0227776
#>  2000-11-01  0.0040101
#> ... 160 more rows. Call `mp_source("nakamura_steinsson")` for citation.
```
