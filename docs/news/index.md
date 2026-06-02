# Changelog

## modeldiag 0.1.1

- Improved multicollinearity reporting in
  [`summary()`](https://rdrr.io/r/base/summary.html) for linear model
  diagnostics.
- Fixed `Authors@R` metadata so package builds derive `Author` and
  `Maintainer` correctly.

## modeldiag 0.1.2

- Added VIF severity levels and per-predictor reporting:
  - Severity mapping: \< 2 = Negligible; 2–5 = Moderate; 5–10 = High;
    \>= 10 = Severe.
  - [`check_vif()`](../reference/check_vif.md) now returns `severities`
    and `collinear_predictors` (predictors with VIF \>= 10).
  - [`summary()`](https://rdrr.io/r/base/summary.html) prints
    per-predictor severities and a severity legend.
  - Tests updated to cover severity labels and collinear predictor
    listing.
- Added linearity diagnostics for linear models using
  [`lmtest::resettest()`](https://rdrr.io/pkg/lmtest/man/resettest.html).
  - [`diagnose_model.lm()`](../reference/diagnose_model.md) now includes
    `linearity` in its test suite.
  - The summary output interprets whether there is evidence against
    linearity.

## modeldiag 0.1.0

CRAN release: 2026-05-28

- Initial CRAN submission.
- Added [`diagnose_model()`](../reference/diagnose_model.md) generic
  function with methods for:
  - Linear models (`lm`)
  - Generalized linear models (`glm`) with binomial and poisson families
  - Cox proportional hazards models (`coxph`)
- Implemented comprehensive diagnostic tests:
  - Multicollinearity (VIF)
  - Heteroscedasticity (Breusch-Pagan test)
  - Autocorrelation (Durbin-Watson test)
  - Normality (Shapiro-Wilk test)
  - Influential observations (Cook’s distance, dfbetas)
  - Overdispersion (Poisson models)
  - Zero-inflation (Poisson models)
  - Proportional hazards (Cox models)
  - Linearity of logit (Logistic models)
  - Goodness of fit (Hosmer-Lemeshow test)
- Added [`print()`](https://rdrr.io/r/base/print.html),
  [`summary()`](https://rdrr.io/r/base/summary.html), and
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) methods for
  diagnostic results
- Comprehensive plotting capabilities for visual diagnostics
- Full documentation with roxygen2
- Unit tests with testthat
