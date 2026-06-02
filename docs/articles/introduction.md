# Introduction to modeldiag

``` r

library(modeldiag)
```

## Overview

Statistical models rely on assumptions for valid inference. Violations
of these assumptions can lead to biased estimates, incorrect standard
errors, and misleading conclusions.

The `modeldiag` package provides a unified framework for diagnosing
these assumptions across multiple model classes, including:

- Linear models
- Logistic regression
- Count models (Poisson)
- Survival models (Cox proportional hazards)

This vignette introduces both the **statistical intuition** behind
common diagnostics and how to implement them using `modeldiag`.

------------------------------------------------------------------------

## Linear Models

Consider the classical linear regression model:

``` math
Y = X\beta + \varepsilon, \quad \varepsilon \sim N(0, \sigma^2 I)
```

Valid inference depends on several assumptions about the error term
$`\varepsilon`$.

### Multicollinearity

Multicollinearity occurs when predictors are highly correlated. This
inflates the variance of coefficient estimates.

The Variance Inflation Factor (VIF) is defined as:

``` math
\text{VIF}_j = \frac{1}{1 - R_j^2}
```

where $`R_j^2`$ is obtained by regressing predictor $`X_j`$ on all other
predictors.

Large VIF values indicate unstable estimates.

### Heteroscedasticity

Heteroscedasticity occurs when:

``` math
\text{Var}(\varepsilon_i) \neq \sigma^2
```

The Breusch–Pagan test evaluates whether residual variance depends on
predictors.

### Autocorrelation

Autocorrelation arises when:

``` math
\text{Cov}(\varepsilon_i, \varepsilon_j) \neq 0
```

The Durbin–Watson statistic tests for first-order autocorrelation.

### Normality of Errors

Many inferential procedures assume:

``` math
\varepsilon \sim N(0, \sigma^2)
```

The Shapiro–Wilk test evaluates this assumption.

### Influential Observations

Influential points disproportionately affect model estimates. Cook’s
distance measures this influence:

``` math
D_i = \frac{( \hat{\beta} - \hat{\beta}*{(i)} )^T X^T X (\hat{\beta} - \hat{\beta}*{(i)})}{p \hat{\sigma}^2}
```

------------------------------------------------------------------------

### Example

``` r

model_lm <- lm(mpg ~ wt + hp + disp, data = mtcars)
diag_lm <- diagnose_model(model_lm)
summary(diag_lm)
#> -- Model Diagnostics Summary ---------------------------------------------------
#> 
#> --  multicollinearity  --
#> 
#> -- Variance inflation factors 
#> 
#>       wt       hp     disp 
#> 4.844618 2.736633 7.324517 
#> -- VIF severity by predictor: 
#> 
#>         wt         hp       disp 
#> "Moderate" "Moderate"     "High" 
#> -- Severity legend: 
#> * < 2 : Negligible
#> * 2 - 5 : Moderate
#> * 5 - 10 : High
#> * >= 10 : Severe
#> 
#> --  heteroskedasticity  --
#> 
#> p-value:  0.8143398 
#> Residual variance appears approximately constant. 
#> 
#> --  autocorrelation  --
#> 
#> p-value:  0.01611772 
#> Residuals appear autocorrelated; consider time-series adjustments. 
#> 
#> --  linearity  --
#> 
#> p-value:  0.000869965 
#> Evidence against linearity in the model; consider adding nonlinear terms or transformations. 
#> 
#> --  normality  --
#> 
#> p-value:  0.03304597 
#> Residuals deviate from normality; check model assumptions. 
#> 
#> --  outliers  --
#> 
#> Number of influential points:  3 
#> Influential observations:  Chrysler Imperial, Toyota Corolla, Maserati Bora 
#> Cook's distances for influential observations:
#> Chrysler Imperial    Toyota Corolla     Maserati Bora 
#>         0.3199707         0.1529771         0.3402911 
#> 3 influential observation(s) detected. Influential observations have Cook's distance above 4/n. Review these cases for leverage, data entry issues, or model fit problems.
```

You can also run individual checks when you only need one diagnostic.

``` r

check_vif(model_lm)
#> $success
#> [1] TRUE
#> 
#> $vif
#>       wt       hp     disp 
#> 4.844618 2.736633 7.324517 
#> 
#> $note
#> [1] "VIF severity by predictor: wt (Moderate), hp (Moderate), disp (High)"
#> 
#> $collinear_predictors
#> character(0)
#> 
#> $severities
#>         wt         hp       disp 
#> "Moderate" "Moderate"     "High"
check_heteroskedasticity(model_lm)
#> 
#>  studentized Breusch-Pagan test
#> 
#> data:  model
#> BP = 0.9459, df = 3, p-value = 0.8143
check_autocorrelation(model_lm)
#> 
#>  Durbin-Watson test
#> 
#> data:  model
#> DW = 1.3673, p-value = 0.01612
#> alternative hypothesis: true autocorrelation is greater than 0
check_linearity(model_lm)
#> 
#>  RESET test
#> 
#> data:  model
#> RESET = 14.01, df1 = 1, df2 = 27, p-value = 0.00087
check_normality(model_lm)
#> 
#>  Shapiro-Wilk normality test
#> 
#> data:  res
#> W = 0.92734, p-value = 0.03305
check_outliers(model_lm)
#> $cooks_distance
#>           Mazda RX4       Mazda RX4 Wag          Datsun 710      Hornet 4 Drive 
#>        1.152035e-02        4.621112e-03        1.598334e-02        1.283888e-04 
#>   Hornet Sportabout             Valiant          Duster 360           Merc 240D 
#>        1.839055e-03        1.560119e-02        1.053270e-02        1.313511e-02 
#>            Merc 230            Merc 280           Merc 280C          Merc 450SE 
#>        2.525382e-03        3.671067e-03        2.606104e-02        1.551454e-03 
#>          Merc 450SL         Merc 450SLC  Cadillac Fleetwood Lincoln Continental 
#>        1.049983e-04        5.648180e-03        7.218880e-05        1.298764e-02 
#>   Chrysler Imperial            Fiat 128         Honda Civic      Toyota Corolla 
#>        3.199707e-01        1.196019e-01        9.092102e-03        1.529771e-01 
#>       Toyota Corona    Dodge Challenger         AMC Javelin          Camaro Z28 
#>        2.215865e-02        4.218196e-02        4.909944e-02        7.181085e-03 
#>    Pontiac Firebird           Fiat X1-9       Porsche 914-2        Lotus Europa 
#>        6.980693e-02        4.163138e-04        1.732523e-06        5.959750e-02 
#>      Ford Pantera L        Ferrari Dino       Maserati Bora          Volvo 142E 
#>        7.279943e-03        1.100867e-02        3.402911e-01        8.796726e-03 
#> 
#> $influential_points
#> Chrysler Imperial    Toyota Corolla     Maserati Bora 
#>                17                20                31
```

------------------------------------------------------------------------

## Logistic Regression

Logistic regression models the probability:

``` math
\text{logit}(P(Y=1)) = X\beta
```

### Key Diagnostics

#### Linearity of the Logit

The model assumes a linear relationship between predictors and the
log-odds:

``` math
\log\left(\frac{p}{1-p}\right)
```

The Box–Tidwell test evaluates this assumption.

#### Goodness of Fit

The Hosmer–Lemeshow test compares observed and expected counts across
groups.

#### Separation

Complete or quasi-complete separation occurs when predictors perfectly
classify outcomes, leading to unstable or infinite estimates.

------------------------------------------------------------------------

### Example

``` r

model_glm <- glm(am ~ wt + hp, data = mtcars, family = binomial)
diag_glm <- diagnose_model(model_glm)
summary(diag_glm)
#> -- Model Diagnostics Summary ---------------------------------------------------
#> 
#> --  multicollinearity  --
#> 
#> -- Variance inflation factors 
#> 
#>       wt       hp 
#> 2.444297 2.444297 
#> -- VIF severity by predictor: 
#> 
#>         wt         hp 
#> "Moderate" "Moderate" 
#> -- Severity legend: 
#> * < 2 : Negligible
#> * 2 - 5 : Moderate
#> * 5 - 10 : High
#> * >= 10 : Severe
#> 
#> --  linearity_logit  --
#> 
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
#> 
#> --  goodness_of_fit  --
#> 
#> p-value:  0.6716511 
#> Model fit appears adequate. 
#> 
#> --  influential_observations  --
#> 
#> Number of influential points:  2 
#> Influential observations:  Mazda RX4 Wag, Toyota Corona 
#> Cook's distances for influential observations:
#> Mazda RX4 Wag Toyota Corona 
#>     0.2034041     0.7917908 
#> 2 influential observation(s) detected. Influential observations have Cook's distance above 4/n. Review these cases for leverage, data entry issues, or model fit problems. 
#> 
#> --  separation_issues  --
#> 
#> No separation issues detected.
```

Individual logistic regression diagnostics can be called directly.

``` r

check_box_tidwell(model_glm)
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
check_hosmer_lemeshow(model_glm)
#> 
#>  Hosmer and Lemeshow goodness of fit (GOF) test
#> 
#> data:  model$y, fitted(model)
#> X-squared = 2.3502, df = 4, p-value = 0.6717
check_influential_glm(model_glm)
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
check_separation(model_glm)
#> [1] "No separation issues detected."
```

------------------------------------------------------------------------

## Poisson Regression

Poisson regression assumes:

``` math
Y \sim \text{Poisson}(\lambda), \quad \log(\lambda) = X\beta
```

### Overdispersion

A key assumption is:

``` math
\text{Var}(Y) = \mathbb{E}(Y)
```

Overdispersion occurs when:

``` math
\text{Var}(Y) > \mathbb{E}(Y)
```

This leads to underestimated standard errors.

### Zero Inflation

Excess zeros beyond what the Poisson model predicts may indicate a
zero-inflated process.

------------------------------------------------------------------------

### Example

``` r

model_pois <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
diag_pois <- diagnose_model(model_pois)
summary(diag_pois)
#> -- Model Diagnostics Summary ---------------------------------------------------
#> 
#> --  multicollinearity  --
#> 
#> -- Variance inflation factors 
#> 
#>       wt       hp 
#> 1.401553 1.401553 
#> -- VIF severity by predictor: 
#> 
#>           wt           hp 
#> "Negligible" "Negligible" 
#> -- Severity legend: 
#> * < 2 : Negligible
#> * 2 - 5 : Moderate
#> * 5 - 10 : High
#> * >= 10 : Severe
#> 
#> --  overdispersion  --
#> 
#> Residual deviance:  12.27804 
#> Degrees of freedom:  29 
#> Ratio:  0.4233806 
#> [OK] No evidence of overdispersion.
#> 
#> --  zero_inflation  --
#> 
#> Observed zeros:  0  ( 0 %)
#> Expected zeros:  3  ( 9.3 %)
#> [OK] No evidence of zero-inflation.
#> 
#> --  influential_observations  --
#> 
#> Number of influential points:  0 
#> No observations exceed the influence threshold.
#> No influential observations detected. Influential observations have Cook's distance above 4/n. Review these cases for leverage, data entry issues, or model fit problems. 
#> 
#> --  residual_analysis  --
#> 
#> Mean residual:  -0.04200633 
#> SD residual:  0.6278888 
#> Min residual:  -0.8656074 
#> Max residual:  1.497036
```

Individual Poisson diagnostics are available for targeted checks.

``` r

check_overdispersion(model_pois)
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
check_zero_inflation(model_pois)
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
check_residual_analysis(model_pois)
#> $mean_residual
#> [1] -0.04200633
#> 
#> $sd_residual
#> [1] 0.6278888
#> 
#> $min_residual
#> [1] -0.8656074
#> 
#> $max_residual
#> [1] 1.497036
```

------------------------------------------------------------------------

## Survival Models

The Cox proportional hazards model assumes:

``` math
h(t | X) = h_0(t) \exp(X\beta)
```

### Proportional Hazards

The key assumption is that hazard ratios are constant over time.

Schoenfeld residuals are used to test:

``` math
\frac{\partial \beta(t)}{\partial t} = 0
```

------------------------------------------------------------------------

### Example

``` r

library(survival)
data(lung)
#> Warning in data(lung): data set 'lung' not found

model_cox <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lung)
diag_cox <- diagnose_model(model_cox)
summary(diag_cox)
#> -- Model Diagnostics Summary ---------------------------------------------------
#> 
#> --  multicollinearity  --
#> 
#> VIF not applicable to Cox models (no intercept). 
#> 
#> --  proportional_hazards  --
#> 
#> Global test p-value:  0.2155549 
#>             chisq df         p
#> age     0.1879877  1 0.6645968
#> sex     2.3054372  1 0.1289220
#> ph.ecog 2.0542488  1 0.1517821
#> GLOBAL  4.4636576  3 0.2155549
#> Proportional hazards assumption appears reasonable. 
#> 
#> --  influential_observations  --
#> 
#> Number of influential points:  10 
#> Influential observations:  3, 6, 17, 32, 36, 37, 70, 84, 88, 128 
#> Max |dfbeta| for influential observations:
#>         3         6        18        33        37        38        71        85 
#> 0.2103167 0.4334764 0.3724475 0.2236608 0.5149764 0.2628997 0.2410623 0.4614677 
#>        89       129 
#> 0.2431150 0.2057780 
#> Influential observations have |dfbeta| > 0.2 for at least one coefficient. Review these cases.
#> 
#> --  functional_form  --
#> 
#> Functional form check: Review plots of martingale residuals vs predictors for nonlinearity.
```

Individual Cox model diagnostics can also be run directly.

``` r

check_proportional_hazards(model_cox)
#>         chisq df    p
#> age     0.188  1 0.66
#> sex     2.305  1 0.13
#> ph.ecog 2.054  1 0.15
#> GLOBAL  4.464  3 0.22
check_influential_coxph(model_cox)
#> $dfbetas
#>              [,1]          [,2]          [,3]
#> 1    0.0019898612 -0.0113782893  6.631006e-03
#> 2    0.0083884583 -0.0044437262 -6.509521e-03
#> 3    0.1035755702  0.1037120879  2.103167e-01
#> 4   -0.0330380008 -0.0286728004  9.415764e-03
#> 5   -0.0205151822  0.0770639215  1.786017e-01
#> 6   -0.4334763687  0.2231627194  4.290399e-02
#> 7    0.0034484450  0.0074885523  2.217729e-02
#> 8   -0.0034354243 -0.0123156330 -1.720884e-03
#> 9   -0.0545859489 -0.0290902376  1.532795e-02
#> 10  -0.0203524286 -0.0299237994  6.005745e-02
#> 11  -0.0402721682 -0.0359013581  6.946416e-03
#> 12  -0.0204388391 -0.1328570080 -1.186494e-01
#> 13  -0.0269608241 -0.0845550087  2.599462e-02
#> 15   0.0500749523  0.0468657714  3.676696e-03
#> 16   0.0255499998 -0.0378692577 -8.237601e-03
#> 17  -0.0673005764  0.0666616602  1.859480e-02
#> 18   0.0677805147  0.2071896397 -3.724475e-01
#> 19  -0.0767254887  0.1041755665  9.100104e-02
#> 20  -0.0490731482 -0.0420620976 -5.505968e-03
#> 21   0.0040113166 -0.0156559500  7.076112e-03
#> 22  -0.1052516339  0.1201631714 -1.113843e-01
#> 23   0.1109014162  0.0419282449 -1.271730e-02
#> 24  -0.0065294229 -0.0179439992 -2.854969e-02
#> 25   0.0100368581 -0.0092537857 -1.174584e-02
#> 26   0.0074129218 -0.0058340366 -9.803345e-04
#> 27   0.0059441198  0.0102630835  2.902271e-02
#> 28   0.0124397186 -0.0267581202  9.171121e-02
#> 29   0.0059686416  0.0035966310  5.447686e-03
#> 30   0.0737321000 -0.0475682053  7.247954e-02
#> 31   0.0083865691 -0.0011721621 -4.563597e-03
#> 32   0.0643205077 -0.0470553678  7.190084e-02
#> 33   0.2236608432  0.0820904131 -1.761672e-01
#> 34  -0.0395963375  0.0956478074  8.223422e-02
#> 35  -0.0348741914 -0.0476125800  8.855613e-02
#> 36  -0.0220042339  0.0908613070  8.036788e-02
#> 37  -0.0273847520  0.2983457171 -5.149764e-01
#> 38  -0.0610066728 -0.2628997035  1.205452e-02
#> 39   0.0581492118 -0.0388606066  5.839455e-02
#> 40   0.0019819640 -0.0765191629  2.040386e-02
#> 41  -0.0346977518  0.0282497267  5.503139e-03
#> 42   0.0504437379  0.0799540315  6.056346e-02
#> 43  -0.0109086809  0.0571036938 -6.101022e-02
#> 44  -0.0378742791  0.0851494384  8.073107e-02
#> 45  -0.0444443723  0.0614457376  1.687138e-02
#> 46   0.0832006255  0.0939766536  5.810064e-02
#> 47   0.0482339850 -0.0284671687 -4.845867e-02
#> 48   0.0098492845  0.0306396494  3.653707e-04
#> 49  -0.0632893286  0.0259644093  8.006261e-02
#> 50   0.0756767437 -0.0407024519  6.631776e-03
#> 51  -0.0681197399 -0.0951568481  3.355310e-02
#> 52   0.0121286330 -0.0378057000 -8.028300e-02
#> 53   0.0622907567 -0.0398198704 -1.336872e-01
#> 54  -0.0228659361 -0.0330608778 -5.927036e-02
#> 55   0.0641758549  0.0836364116 -8.760249e-03
#> 56   0.0098180554 -0.0392584149 -1.201191e-01
#> 57   0.0319091035  0.1291139999 -1.443057e-01
#> 58  -0.0498881164 -0.0369076822  7.852703e-02
#> 59   0.0299205943 -0.0372026229 -1.656423e-04
#> 60   0.0018451697  0.0402453130  1.318178e-03
#> 61  -0.0367924289 -0.0534874473 -3.852699e-02
#> 62  -0.0785338667 -0.0322244907  2.131399e-02
#> 63   0.0535821256 -0.0324735308 -8.568132e-03
#> 64   0.0183300113  0.1130154262 -2.729181e-02
#> 65   0.0352581667 -0.0346338143 -7.358120e-03
#> 66   0.0221439514 -0.0433611232  7.221090e-02
#> 67   0.0045346445  0.0535580295  5.434215e-02
#> 68  -0.0397442023 -0.1522338787  1.527123e-01
#> 69   0.0102568136 -0.0115179178 -1.423718e-02
#> 70   0.0086164345 -0.0255925458  6.027162e-03
#> 71  -0.0470406846  0.1049392189  2.410623e-01
#> 72  -0.0860754948  0.0580683479  1.408366e-02
#> 73   0.0740966086 -0.0479245443  7.394157e-02
#> 74  -0.1758878058 -0.0413044150  2.481401e-02
#> 75  -0.0719470999  0.0762086036  1.173566e-02
#> 76   0.0148082806  0.0176939652 -4.434004e-04
#> 77  -0.0046672396  0.0192137723 -1.813395e-02
#> 78  -0.0266390434  0.0438138804  5.989556e-03
#> 79   0.1782533223 -0.0375607865 -1.604460e-01
#> 80   0.0816850630 -0.0351846583 -9.804956e-02
#> 81   0.0152779990  0.0793079902  1.189438e-01
#> 82  -0.0636198968 -0.0416836601 -1.306606e-03
#> 83   0.0698051012  0.0177935997 -8.281316e-03
#> 84  -0.1503150506  0.0968834915  1.709307e-02
#> 85   0.4614677138  0.1477727601 -8.810651e-02
#> 86   0.0154474340 -0.0164739726  5.604348e-04
#> 87   0.0085719629 -0.0322435760  6.264670e-03
#> 88  -0.0013733406 -0.0371414066 -9.646258e-02
#> 89   0.2431149833 -0.1546166164 -3.292858e-02
#> 90   0.0276317853 -0.0270515449  4.773117e-02
#> 91   0.0045977579  0.0259099959  5.980967e-02
#> 92   0.0177403510 -0.0242814478  4.411387e-03
#> 93   0.0230650286 -0.0412215026 -1.773923e-02
#> 94  -0.0426823226  0.0720064653  7.098509e-03
#> 95  -0.0564521384 -0.0891532850  1.010963e-01
#> 96   0.0559648269 -0.0471252036  7.343045e-02
#> 97   0.0308758962 -0.0326325335 -4.524247e-03
#> 98   0.0032395515 -0.0123927821  6.627081e-03
#> 99   0.0026180610  0.0263848968 -1.344832e-03
#> 100  0.0721113689  0.1060389633 -1.188152e-01
#> 101  0.0177466831 -0.0726996366  7.216985e-02
#> 102  0.0117130597  0.0108225866 -3.319975e-03
#> 103  0.0069108034 -0.0005234452  5.100927e-03
#> 104 -0.0001501724 -0.0393164284 -9.816928e-03
#> 105 -0.0263533710 -0.0274232475  5.503929e-02
#> 106  0.0177062136 -0.0349541815 -5.748319e-03
#> 107  0.0755001113 -0.0979229433 -3.288944e-03
#> 108  0.0304753917 -0.0432099350 -2.589854e-02
#> 109  0.0173499082  0.0059787081  4.846321e-06
#> 110 -0.0058002274 -0.0133607874  4.140821e-04
#> 111  0.0700097729 -0.0389969262 -1.378760e-01
#> 112 -0.1221994328 -0.0383062757  2.203808e-02
#> 113  0.0220568694 -0.0122813838 -4.022791e-05
#> 114  0.0996231959  0.0939974470 -1.118615e-01
#> 115 -0.0012572451  0.0111730974  3.545064e-04
#> 116  0.0908990976 -0.0473912195  6.914276e-02
#> 117 -0.0456730504 -0.0178610689  4.539084e-02
#> 118 -0.0345055675  0.1105009415 -1.877604e-01
#> 119 -0.0013697789  0.0093433174 -2.210654e-02
#> 120 -0.0482933670  0.0149483922  1.588416e-02
#> 121  0.0033460475 -0.0064066864 -2.122262e-03
#> 122 -0.0327622814  0.0595625887  6.736237e-02
#> 123 -0.0070824888 -0.0145286411  1.332550e-02
#> 124  0.0548688520 -0.0463741344  7.072927e-02
#> 125 -0.0152959088  0.0160355428  4.569608e-02
#> 126  0.0086214315 -0.0274821266  1.781469e-03
#> 127 -0.1058282819 -0.0427239316  4.120953e-03
#> 128  0.0088710803 -0.0443495143 -1.725015e-02
#> 129 -0.2057779582 -0.2008082718 -1.535928e-01
#> 130  0.0645107804 -0.0618179518  5.331680e-02
#> 131 -0.0236343483  0.0568749151  5.914936e-03
#> 132 -0.0561439462 -0.0321416892  1.270814e-02
#> 133 -0.0586991589 -0.0274863346 -3.480657e-02
#> 134  0.0630172285 -0.0910178391 -1.778694e-03
#> 135  0.0258463538 -0.0304889411 -6.461534e-02
#> 136 -0.1279169393 -0.1704506884 -1.371350e-01
#> 137 -0.0154086097  0.0390418564  4.024052e-03
#> 138  0.0669074111  0.0465558493 -8.898263e-02
#> 139  0.0351034039  0.0152623303 -7.214797e-03
#> 140 -0.0226985456 -0.0324411456 -3.972187e-02
#> 141  0.0325169319  0.0523084757  4.975478e-02
#> 142 -0.1365688305  0.0766382561  2.797470e-02
#> 143 -0.0064160386 -0.0033925776  1.074984e-02
#> 144  0.0178556896  0.1126558464 -2.672885e-02
#> 145  0.0810398492  0.0771006813 -1.007872e-02
#> 146  0.0521580824 -0.0609825008 -2.466540e-03
#> 147  0.0265819228 -0.0190045447 -3.048193e-02
#> 148 -0.0624588814 -0.0373134387  8.855150e-03
#> 149  0.1854018296 -0.0391263682 -1.543971e-01
#> 150 -0.0146643351  0.0695887941 -7.216112e-02
#> 151  0.0179795901 -0.0245133503  4.575647e-03
#> 152  0.0100768982  0.0424254888  9.334078e-02
#> 153 -0.0021287480 -0.0376693165  3.921463e-02
#> 154 -0.0772132998  0.0877302195  6.475027e-03
#> 155 -0.0559623188 -0.0325046362  7.261258e-02
#> 156 -0.0176598590  0.0235222457 -4.779548e-02
#> 157 -0.0293957133 -0.0773271267  1.311357e-02
#> 158  0.0068052932  0.0062231396 -1.786702e-02
#> 159 -0.0023248131 -0.0339887124  9.058203e-04
#> 160  0.0424716224 -0.0699038077 -1.947040e-04
#> 161 -0.0029328740 -0.0493669420  5.139855e-02
#> 162 -0.1285114884  0.0757464819  1.809179e-02
#> 163 -0.0419861306  0.0756456597 -1.289759e-01
#> 164 -0.0018120797 -0.0384883650 -3.677971e-03
#> 165 -0.0066361460  0.0689299192  5.032142e-03
#> 166  0.0083931592 -0.0261948636  2.556857e-02
#> 167 -0.0242361426  0.0827222971 -1.754309e-03
#> 168 -0.0747706920 -0.0344385691 -4.081238e-02
#> 169 -0.0145645184 -0.0347051334  4.195715e-03
#> 170  0.0176905893 -0.0301505049 -6.129940e-02
#> 171  0.0176428967  0.0412026013  1.648694e-03
#> 172 -0.0207180251  0.0703990895 -7.092345e-02
#> 173 -0.0423107365 -0.0344824534  9.182614e-03
#> 174  0.0573040836 -0.0398398542  3.132242e-02
#> 175  0.0706157052  0.0386845932 -7.955815e-03
#> 176  0.0175625437 -0.0498843953  3.139427e-03
#> 177 -0.0376920672 -0.0274684521  5.621938e-02
#> 178 -0.0600856029  0.0853066677  5.266695e-03
#> 179 -0.0816891797  0.1008438435  1.361401e-03
#> 180 -0.0323883857 -0.0334131872  3.991434e-02
#> 181  0.0057921807  0.0224610020  5.465954e-02
#> 182  0.0704448675  0.0159698178  2.765059e-02
#> 183  0.0267115415  0.0667750050 -7.525088e-02
#> 184 -0.0060728312 -0.0466007828  7.070918e-03
#> 185  0.0232586076 -0.0295436234  2.647552e-02
#> 186  0.0407291304 -0.0321686957  2.626321e-02
#> 187  0.0154698862  0.0239576638  2.675119e-02
#> 188  0.0114213958  0.0173517892  4.243866e-02
#> 189  0.0071288629 -0.0384936423 -1.060828e-02
#> 190 -0.0444176004 -0.0317421508 -5.581723e-02
#> 191  0.0159454594 -0.0165595624  1.085787e-03
#> 192 -0.0993555065 -0.0441102767  9.409598e-02
#> 193 -0.0969346845 -0.0400537973  1.122165e-02
#> 194 -0.0035331076  0.0285724239  5.525394e-03
#> 195  0.0137088532 -0.0175698624  1.987928e-03
#> 196 -0.0309687876  0.0170386947  5.052130e-02
#> 197  0.0010346898 -0.0410911928  5.400080e-03
#> 198 -0.0037269810  0.0355762475  5.400631e-03
#> 199  0.0187209222 -0.0265200538  2.411146e-02
#> 200 -0.0230595855 -0.0389285154 -1.259133e-04
#> 201  0.0094105104  0.1112473351 -2.467330e-02
#> 202  0.0842868100 -0.0438952808 -3.013321e-02
#> 203 -0.0037067535 -0.0270728033  2.857329e-02
#> 204  0.0158629290 -0.0189412224  1.702651e-02
#> 205 -0.0036010735 -0.0261576214  2.763588e-02
#> 206 -0.0212687130 -0.0394605273  7.407970e-02
#> 207  0.0105619971 -0.0226867080  2.168648e-02
#> 208 -0.0776674665  0.0507321487  7.253475e-02
#> 209 -0.0330271125  0.0320311931  1.082496e-02
#> 210  0.0072448367 -0.0225298740  2.727321e-03
#> 211  0.0024952402 -0.0270962764  2.750152e-02
#> 212 -0.0192850166  0.0283425246  8.471276e-03
#> 213 -0.0241399125  0.0221530443  9.253175e-03
#> 214  0.0016320746 -0.0158743625 -1.181062e-02
#> 215  0.0140249859 -0.0436593170 -2.151875e-02
#> 216 -0.0087475917  0.0282965084  6.519916e-03
#> 217  0.0406981440 -0.0232985124 -3.285404e-03
#> 218  0.0188001723 -0.0170423323  2.727106e-02
#> 219 -0.0220949939 -0.0575983999 -4.376584e-02
#> 220  0.0044258604 -0.0148088178  1.480410e-02
#> 221 -0.0166117087  0.0236672521  7.910138e-03
#> 222 -0.0223032796 -0.0364472324  9.439237e-03
#> 223  0.0926762964 -0.0369128518 -2.492383e-02
#> 224 -0.0641439711  0.0246405958  1.666007e-02
#> 225  0.0433683096  0.0094356190  1.811624e-02
#> 226 -0.0163049880 -0.0208684591 -1.240141e-02
#> 227 -0.0092500861  0.0171511025  6.199495e-03
#> 228  0.0095030791 -0.0237181596  2.452578e-03
#> 
#> $influential_points
#>   3   6  18  33  37  38  71  85  89 129 
#>   3   6  17  32  36  37  70  84  88 128
check_functional_form_coxph(model_cox)
#> [1] "Functional form check: Review plots of martingale residuals vs predictors for nonlinearity."
```

------------------------------------------------------------------------

## Visualization

Diagnostic plots help identify violations visually.

``` r

plot(diag_lm)
```

![](introduction_files/figure-html/plotting-1.png)

------------------------------------------------------------------------

## Conclusion

The `modeldiag` package provides a unified and extensible framework for
model diagnostics, combining statistical rigor with practical usability.

By integrating multiple diagnostic tools into a consistent interface, it
simplifies the process of validating model assumptions across diverse
modeling frameworks.

## References

Cook, R. D., & Weisberg, S. (1982). *Residuals and Influence in
Regression*. Chapman & Hall.

Breusch, T. S., & Pagan, A. R. (1979). *A Simple Test for
Heteroscedasticity and Random Coefficient Variation*. Econometrica.

Durbin, J., & Watson, G. S. (1950, 1951). *Testing for Serial
Correlation in Least Squares Regression*. Biometrika.

Shapiro, S. S., & Wilk, M. B. (1965). *An Analysis of Variance Test for
Normality*. Biometrika.

Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). *Applied
Logistic Regression*. Wiley.

Cox, D. R. (1972). *Regression Models and Life-Tables*. JRSS.

Cameron, A. C., & Trivedi, P. K. (2013). *Regression Analysis of Count
Data*. Cambridge University Press.
