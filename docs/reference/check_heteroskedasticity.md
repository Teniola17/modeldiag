# Check Heteroskedasticity

Performs Breusch-Pagan test for heteroskedasticity.

## Usage

``` r
check_heteroskedasticity(model)
```

## Arguments

- model:

  A fitted lm object.

## Value

An htest object or NA if computation fails.

## Examples

``` r
model <- lm(mpg ~ wt + hp, data = mtcars)
check_heteroskedasticity(model)
#> 
#>  studentized Breusch-Pagan test
#> 
#> data:  model
#> BP = 0.88072, df = 2, p-value = 0.6438
#> 
```
