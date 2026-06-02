# Check Influential Observations

Identifies influential observations using Cook's distance.

## Usage

``` r
check_outliers(model, cutoff = 4/length(residuals(model)))
```

## Arguments

- model:

  A fitted model object.

- cutoff:

  Cook's distance cutoff. Defaults to 4 divided by the number of
  observations.

## Value

A list containing Cook's distances and influential point indices.

## Examples

``` r
model <- lm(mpg ~ wt + hp, data = mtcars)
check_outliers(model)
#> $cooks_distance
#>           Mazda RX4       Mazda RX4 Wag          Datsun 710      Hornet 4 Drive 
#>        1.589652e-02        5.464779e-03        2.070651e-02        4.724822e-05 
#>   Hornet Sportabout             Valiant          Duster 360           Merc 240D 
#>        2.736184e-04        2.155064e-02        1.255218e-02        1.677650e-02 
#>            Merc 230            Merc 280           Merc 280C          Merc 450SE 
#>        2.188702e-03        1.554996e-03        1.215737e-02        1.423008e-03 
#>          Merc 450SL         Merc 450SLC  Cadillac Fleetwood Lincoln Continental 
#>        1.458960e-04        6.266049e-03        2.786686e-05        1.780910e-02 
#>   Chrysler Imperial            Fiat 128         Honda Civic      Toyota Corolla 
#>        4.236109e-01        1.574263e-01        9.371446e-03        2.083933e-01 
#>       Toyota Corona    Dodge Challenger         AMC Javelin          Camaro Z28 
#>        2.791982e-02        2.087419e-02        2.751510e-02        9.943527e-03 
#>    Pontiac Firebird           Fiat X1-9       Porsche 914-2        Lotus Europa 
#>        1.443199e-02        5.920440e-04        5.674986e-06        7.353985e-02 
#>      Ford Pantera L        Ferrari Dino       Maserati Bora          Volvo 142E 
#>        8.919701e-03        5.732672e-03        2.720397e-01        5.600804e-03 
#> 
#> $influential_points
#> Chrysler Imperial          Fiat 128    Toyota Corolla     Maserati Bora 
#>                17                18                20                31 
#> 
```
