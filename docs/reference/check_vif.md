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
