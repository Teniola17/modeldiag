# Check Variance Inflation Factors

Computes variance inflation factors to detect multicollinearity.

## Usage

``` r
check_vif(model)
```

## Arguments

- model:

  A fitted model object.

## Value

A list describing whether VIF computation succeeded. Successful results
include a \`vif\` element containing the variance inflation factors.

## Examples

``` r
model <- lm(mpg ~ wt + hp + disp, data = mtcars)
check_vif(model)
#> $success
#> [1] TRUE
#> 
#> $vif
#>       wt       hp     disp 
#> 4.844618 2.736633 7.324517 
#> 
#> $note
#> [1] "VIF severity by predictor: wt (Moderate), hp (Moderate), disp (High)"
#> 
#> $collinear_predictors
#> character(0)
#> 
#> $severities
#>         wt         hp       disp 
#> "Moderate" "Moderate"     "High" 
#> 
```
