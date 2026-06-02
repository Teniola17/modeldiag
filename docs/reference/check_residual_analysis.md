# Check Residual Summary

Summarizes deviance residuals for a generalized linear model.

## Usage

``` r
check_residual_analysis(model)
```

## Arguments

- model:

  A fitted model object.

## Value

A list of residual summary statistics, or NA if computation fails.

## Examples

``` r
model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
check_residual_analysis(model)
#> $mean_residual
#> [1] -0.04200633
#> 
#> $sd_residual
#> [1] 0.6278888
#> 
#> $min_residual
#> [1] -0.8656074
#> 
#> $max_residual
#> [1] 1.497036
#> 
```
