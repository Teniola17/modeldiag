# Check Influential Observations in GLMs

Identifies influential observations in generalized linear models using
Cook's distance.

## Usage

``` r
check_influential_glm(model)
```

## Arguments

- model:

  A fitted glm object.

## Value

A list containing Cook's distances and influential point indices.

## Examples

``` r
model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_influential_glm(model)
#> $cooks_distance
#>           Mazda RX4       Mazda RX4 Wag          Datsun 710      Hornet 4 Drive 
#>        1.725110e-02        2.034041e-01        1.054039e-03        1.686756e-03 
#>   Hornet Sportabout             Valiant          Duster 360           Merc 240D 
#>        3.512351e-03        4.413520e-05        9.441132e-02        1.553660e-04 
#>            Merc 230            Merc 280           Merc 280C          Merc 450SE 
#>        1.805692e-03        1.692468e-04        1.692468e-04        9.043823e-07 
#>          Merc 450SL         Merc 450SLC  Cadillac Fleetwood Lincoln Continental 
#>        1.047495e-04        5.277112e-05        1.234078e-13        1.734386e-14 
#>   Chrysler Imperial            Fiat 128         Honda Civic      Toyota Corolla 
#>        1.619112e-13        1.309867e-03        7.429752e-07        7.402953e-06 
#>       Toyota Corona    Dodge Challenger         AMC Javelin          Camaro Z28 
#>        7.917908e-01        2.834875e-04        8.715763e-04        1.812379e-03 
#>    Pontiac Firebird           Fiat X1-9       Porsche 914-2        Lotus Europa 
#>        1.563880e-05        2.899997e-05        9.799693e-05        2.790544e-09 
#>      Ford Pantera L        Ferrari Dino       Maserati Bora          Volvo 142E 
#>        5.218144e-03        2.458477e-03        8.109529e-02        1.007256e-01 
#> 
#> $influential_points
#> Mazda RX4 Wag Toyota Corona 
#>             2            21 
#> 
```
