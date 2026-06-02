# Check Zero Inflation

Compares observed zeros with the number expected under a fitted Poisson
glm.

## Usage

``` r
check_zero_inflation(model)
```

## Arguments

- model:

  A fitted Poisson glm object.

## Value

A list with zero-inflation diagnostics, or NA if the model is not
Poisson or computation fails.

## Examples

``` r
model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
check_zero_inflation(model)
#> $observed_zeros
#> [1] 0
#> 
#> $expected_zeros
#> [1] 2.978489
#> 
#> $prop_observed
#> [1] 0
#> 
#> $prop_expected
#> [1] 0.09307777
#> 
#> $zero_inflated
#> [1] FALSE
#> 
```
