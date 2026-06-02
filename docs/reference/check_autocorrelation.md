# Check Autocorrelation

Performs the Durbin-Watson test for first-order autocorrelation in
residuals.

## Usage

``` r
check_autocorrelation(model)
```

## Arguments

- model:

  A fitted lm object.

## Value

An htest object or NA if computation fails.

## Examples

``` r
model <- lm(mpg ~ wt + hp, data = mtcars)
check_autocorrelation(model)
#> 
#>  Durbin-Watson test
#> 
#> data:  model
#> DW = 1.3624, p-value = 0.02061
#> alternative hypothesis: true autocorrelation is greater than 0
#> 
```
