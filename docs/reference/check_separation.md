# Check Separation in GLMs

Checks for simple indicators of complete or quasi-complete separation.

## Usage

``` r
check_separation(model)
```

## Arguments

- model:

  A fitted glm object.

## Value

A character message describing whether separation was detected, or NA if
the model is not a glm.

## Examples

``` r
model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_separation(model)
#> [1] "No separation issues detected."
```
