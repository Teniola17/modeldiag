# Check Normality of Residuals

Performs the Shapiro-Wilk test on model residuals.

## Usage

``` r
check_normality(model)
```

## Arguments

- model:

  A fitted model object.

## Value

An htest object or NA if computation fails.

## Examples

``` r
model <- lm(mpg ~ wt + hp, data = mtcars)
check_normality(model)
#> 
#>  Shapiro-Wilk normality test
#> 
#> data:  res
#> W = 0.92792, p-value = 0.03427
#> 
```
