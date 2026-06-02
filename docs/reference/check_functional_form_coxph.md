# Check Cox Model Functional Form

Provides guidance for checking nonlinear functional form in Cox models
using martingale residuals.

## Usage

``` r
check_functional_form_coxph(model)
```

## Arguments

- model:

  A fitted coxph object.

## Value

A character message or NA if computation fails.

## Examples

``` r
if (requireNamespace("survival", quietly = TRUE)) {
  model <- survival::coxph(
    survival::Surv(time, status) ~ age + sex,
    data = survival::lung
  )
  check_functional_form_coxph(model)
}
#> [1] "Functional form check: Review plots of martingale residuals vs predictors for nonlinearity."
```
