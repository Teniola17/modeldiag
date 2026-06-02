# Check Logistic Linearity with Box-Tidwell Test

Performs a Box-Tidwell test for linearity of continuous predictors in
the logit.

## Usage

``` r
check_box_tidwell(model)
```

## Arguments

- model:

  A fitted glm object.

## Value

A Box-Tidwell test result or NA if computation fails.

## Examples

``` r
model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_box_tidwell(model)
#>    MLE of lambda Score Statistic (t) Pr(>|t|)  
#> wt     -0.088743              2.2318  0.03412 *
#> hp      3.205811              0.8980  0.37711  
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> iterations =  13 
#> 
#> Score test for null hypothesis that all lambdas = 1:
#> F = 3.6654, df = 2 and 27, Pr(>F) = 0.03905
#> 
```
