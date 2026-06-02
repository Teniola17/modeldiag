# Check Logistic Goodness of Fit

Performs the Hosmer-Lemeshow goodness-of-fit test for binomial glm
models.

## Usage

``` r
check_hosmer_lemeshow(model)
```

## Arguments

- model:

  A fitted binomial glm object.

## Value

An htest object or NA if computation fails or the model is not binomial.

## Examples

``` r
model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_hosmer_lemeshow(model)
#> 
#>  Hosmer and Lemeshow goodness of fit (GOF) test
#> 
#> data:  model$y, fitted(model)
#> X-squared = 2.3502, df = 4, p-value = 0.6717
#> 
```
