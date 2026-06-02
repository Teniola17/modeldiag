# modeldiag 0.1.1

* Improved multicollinearity reporting in `summary()` for linear model diagnostics.
* Fixed `Authors@R` metadata so package builds derive `Author` and `Maintainer` correctly.

# modeldiag 0.1.2

* Added VIF severity levels and per-predictor reporting:
  - Severity mapping: < 2 = Negligible; 2–5 = Moderate; 5–10 = High; >= 10 = Severe.
  - `check_vif()` now returns `severities` and `collinear_predictors` (predictors with VIF >= 10).
  - `summary()` prints per-predictor severities and a severity legend.
  - Tests updated to cover severity labels and collinear predictor listing.

# modeldiag 0.1.0

* Initial CRAN submission.
* Added `diagnose_model()` generic function with methods for:
  - Linear models (`lm`)
  - Generalized linear models (`glm`) with binomial and poisson families
  - Cox proportional hazards models (`coxph`)
* Implemented comprehensive diagnostic tests:
  - Multicollinearity (VIF)
  - Heteroscedasticity (Breusch-Pagan test)
  - Autocorrelation (Durbin-Watson test)
  - Normality (Shapiro-Wilk test)
  - Influential observations (Cook's distance, dfbetas)
  - Overdispersion (Poisson models)
  - Zero-inflation (Poisson models)
  - Proportional hazards (Cox models)
  - Linearity of logit (Logistic models)
  - Goodness of fit (Hosmer-Lemeshow test)
* Added `print()`, `summary()`, and `plot()` methods for diagnostic results
* Comprehensive plotting capabilities for visual diagnostics
* Full documentation with roxygen2
* Unit tests with testthat
