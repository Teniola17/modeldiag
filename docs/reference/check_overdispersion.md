# Check Overdispersion

Checks whether a Poisson glm appears overdispersed using the residual
deviance to degrees-of-freedom ratio.

## Usage

``` r
check_overdispersion(model)
```

## Arguments

- model:

  A fitted Poisson glm object.

## Value

A list with overdispersion diagnostics, or NA if the model is not
Poisson or computation fails.

## Examples

``` r
model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
check_overdispersion(model)
#> $residual_deviance
#> [1] 12.27804
#> 
#> $df
#> [1] 29
#> 
#> $ratio
#> [1] 0.4233806
#> 
#> $overdispersed
#> [1] FALSE
#> 
```
