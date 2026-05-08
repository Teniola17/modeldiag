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