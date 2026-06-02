# Check Proportional Hazards

Performs a proportional hazards test for a fitted Cox model using
Schoenfeld residuals.

## Usage

``` r
check_proportional_hazards(model)
```

## Arguments

- model:

  A fitted coxph object.

## Value

A cox.zph result or NA if computation fails.

## Examples

``` r
if (requireNamespace("survival", quietly = TRUE)) {
  model <- survival::coxph(
    survival::Surv(time, status) ~ age + sex,
    data = survival::lung
  )
  check_proportional_hazards(model)
}
#>        chisq df    p
#> age    0.209  1 0.65
#> sex    2.608  1 0.11
#> GLOBAL 2.771  2 0.25
```
