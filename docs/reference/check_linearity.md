# Check Linearity

Performs Ramsey's RESET test for linear model misspecification.

## Usage

``` r
check_linearity(model, power = 2)
```

## Arguments

- model:

  A fitted lm object.

- power:

  Powers of fitted values to include in the test.

## Value

An htest object with an added note, or NA if computation fails.

## Examples

``` r
model <- lm(mpg ~ wt + hp, data = mtcars)
check_linearity(model)
#> 
#>  RESET test
#> 
#> data:  model
#> RESET = 14.416, df1 = 1, df2 = 28, p-value = 0.0007226
#> 
```
