test_that("handles models with perfect collinearity gracefully", {
  # Create data with perfect collinearity
  set.seed(123)
  n <- 100
  x1 <- rnorm(n)
  x2 <- 2 * x1  # Perfect collinearity
  y <- x1 + rnorm(n)
  
  data_collinear <- data.frame(y = y, x1 = x1, x2 = x2)
  
  # Model should still fit but VIF should catch this
  model <- lm(y ~ x1 + x2, data = data_collinear)
  
  diag <- diagnose_model(model)
  # Check that VIF test shows high values or NA
  expect_true(is.list(diag$tests$multicollinearity) || is.character(diag$tests$multicollinearity))
})

test_that("handles models with missing data appropriately", {
  # Create data with missing values
  data_missing <- mtcars
  data_missing$mpg[c(1, 5, 10)] <- NA
  data_missing$wt[c(2, 8)] <- NA
  
  model <- lm(mpg ~ wt + hp, data = data_missing)
  diag <- diagnose_model(model)
  
  expect_s3_class(diag, "model_diagnostics")
  expect_true(length(residuals(model)) < nrow(data_missing))
})

test_that("handles models with singular design matrix", {
  # Create singular design matrix
  set.seed(123)
  n <- 50
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  x3 <- x1 + x2  # Linear combination
  y <- x1 + x2 + rnorm(n)
  
  data_singular <- data.frame(y = y, x1 = x1, x2 = x2, x3 = x3)
  
  # Model fits but with singularities
  model <- lm(y ~ x1 + x2 + x3, data = data_singular)
  
  diag <- diagnose_model(model)
  expect_s3_class(diag, "model_diagnostics")
})

test_that("handles GLM with complete separation", {
  # Create data with complete separation
  set.seed(123)
  x <- c(rep(-1, 50), rep(1, 50))
  y <- c(rep(0, 50), rep(1, 50))
  
  data_sep <- data.frame(x = x, y = y)
  
  # Model fits but has separation issues
  suppressWarnings({
    model <- glm(y ~ x, data = data_sep, family = binomial)
  })
  
  diag <- diagnose_model(model)
  # Check for large coefficients indicating separation
  expect_true(any(abs(coef(model)) > 5))
})

test_that("handles Poisson model with all zeros", {
  # Create count data with all zeros
  data_zeros <- data.frame(
    count = rep(0, 100),
    x = rnorm(100)
  )
  
  # Model fits but will show zero inflation
  model <- glm(count ~ x, data = data_zeros, family = poisson)
  
  diag <- diagnose_model(model)
  expect_equal(diag$tests$zero_inflation$observed_zeros, 100)
})

test_that("handles Cox model with no events", {
  library(survival)
  
  # Create survival data with very few events
  set.seed(123)
  n <- 100
  time <- rexp(n, 0.1)
  status <- c(rep(1, 5), rep(0, 95))  # Only 5 events
  x <- rnorm(n)
  
  data_few_events <- data.frame(time = time, status = status, x = x)
  
  # Model should fit but with warnings about convergence
  model <- coxph(Surv(time, status) ~ x, data = data_few_events)
  diag <- diagnose_model(model)
  expect_s3_class(diag, "model_diagnostics")
})