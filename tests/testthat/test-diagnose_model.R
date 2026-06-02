# test_that("diagnose_model works for lm", {
#   model <- lm(mpg ~ wt + hp, data = mtcars)
#   diag <- diagnose_model(model)
#   expect_s3_class(diag, "model_diagnostics")
#   expect_equal(diag$model_type, "lm")
#   expect_true("multicollinearity" %in% names(diag$tests))
#   expect_true("heteroskedasticity" %in% names(diag$tests))
# })

# test_that("diagnose_model works for glm binomial", {
#   model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
#   diag <- diagnose_model(model)
#   expect_s3_class(diag, "model_diagnostics")
#   expect_equal(diag$model_type, "glm")
#   expect_true("multicollinearity" %in% names(diag$tests))
#   expect_true("linearity_logit" %in% names(diag$tests))
# })

# test_that("diagnose_model works for glm poisson", {
#   model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
#   diag <- diagnose_model(model)
#   expect_s3_class(diag, "model_diagnostics")
#   expect_equal(diag$model_type, "glm")
#   expect_true("overdispersion" %in% names(diag$tests))
#   expect_true("zero_inflation" %in% names(diag$tests))
# })

# test_that("diagnose_model works for coxph", {
#   library(survival)
#   data(lung)
#   model <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lung)
#   diag <- diagnose_model(model)
#   expect_s3_class(diag, "model_diagnostics")
#   expect_equal(diag$model_type, "coxph")
#   expect_true("proportional_hazards" %in% names(diag$tests))
#   expect_true("influential_observations" %in% names(diag$tests))
# })

# test_that("print method works", {
#   model <- lm(mpg ~ wt, data = mtcars)
#   diag <- diagnose_model(model)
#   expect_output(print(diag), "Model type: lm")
# })

# test_that("summary method works", {
#   model <- lm(mpg ~ wt, data = mtcars)
#   diag <- diagnose_model(model)
#   expect_output(summary(diag), "Model Diagnostics Summary")
# })

# test_that("plot method works without error", {
#   model <- lm(mpg ~ wt, data = mtcars)
#   diag <- diagnose_model(model)
#   expect_silent(plot(diag))
# })

test_that("diagnose_model works for lm", {
  model <- lm(mpg ~ wt + hp, data = mtcars)
  diag <- diagnose_model(model)

  expect_s3_class(diag, "model_diagnostics")
  expect_equal(diag$model_type, "lm")
  expect_true("multicollinearity" %in% names(diag$tests))
  expect_true("heteroskedasticity" %in% names(diag$tests))
  expect_true("linearity" %in% names(diag$tests))
})

test_that("diagnose_model works for glm binomial", {
  model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
  diag <- diagnose_model(model)

  expect_s3_class(diag, "model_diagnostics")
  expect_equal(diag$model_type, "glm")
  expect_true("multicollinearity" %in% names(diag$tests))
  expect_true("linearity_logit" %in% names(diag$tests))
})

test_that("diagnose_model works for glm poisson", {
  model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
  diag <- diagnose_model(model)

  expect_s3_class(diag, "model_diagnostics")
  expect_equal(diag$model_type, "glm")
  expect_true("overdispersion" %in% names(diag$tests))
  expect_true("zero_inflation" %in% names(diag$tests))
})

test_that("diagnose_model works for coxph", {
  skip_if_not_installed("survival")

  model <- survival::coxph(
    survival::Surv(time, status) ~ age + sex + ph.ecog,
    data = survival::lung
  )

  diag <- diagnose_model(model)

  expect_s3_class(diag, "model_diagnostics")
  expect_equal(diag$model_type, "coxph")
  expect_true("proportional_hazards" %in% names(diag$tests))
  expect_true("influential_observations" %in% names(diag$tests))
})

test_that("print method works", {
  model <- lm(mpg ~ wt, data = mtcars)
  diag <- diagnose_model(model)

  expect_output(print(diag), "Model type: lm")
})

test_that("summary method works", {
  model <- lm(mpg ~ wt, data = mtcars)
  diag <- diagnose_model(model)

  output <- capture.output(summary(diag))
  expect_true(any(grepl("Model Diagnostics Summary", output)))
})

test_that("summary reports linearity test for lm models", {
  model <- lm(mpg ~ wt + hp, data = mtcars)
  diag <- diagnose_model(model)

  expect_true("linearity" %in% names(diag$tests))
  output <- capture.output(summary(diag))
  expect_true(any(grepl("p-value:", output)))
  expect_true(any(grepl("linearity", output)))
  expect_true(any(grepl("No evidence against linearity in the model|Evidence against linearity in the model", output)))
})

test_that("summary reports VIF values for linear models", {
  model <- lm(mpg ~ wt + hp, data = mtcars)
  diag <- diagnose_model(model)

  output <- capture.output(summary(diag))
  expect_true(any(grepl("Variance inflation factors", output)))
  expect_true(any(grepl("VIF severity by predictor:", output)))
  expect_true(any(grepl("Severity legend:", output)))
})

test_that("summary flags multicollinearity when VIF is high", {
  set.seed(123)
  df <- data.frame(
    x1 = seq(1, 100),
    x2 = seq(1, 100) + rnorm(100, sd = 0.01),
    y = seq(1, 100) + rnorm(100)
  )
  model <- lm(y ~ x1 + x2, data = df)
  diag <- diagnose_model(model)

  output <- capture.output(summary(diag))
  expect_true(any(grepl("VIF severity by predictor:", output)))
  expect_true(any(grepl("Severity legend:", output)))
  expect_true(any(grepl("Severe", output)))
  expect_true(length(diag$tests$multicollinearity$collinear_predictors) > 0)
  expect_true(any(diag$tests$multicollinearity$severities == "Severe"))
})

test_that("plot method works without error", {
  model <- lm(mpg ~ wt, data = mtcars)
  diag <- diagnose_model(model)

  # suppress plotting safely
  pdf(NULL)
  plot(diag)
  dev.off()

  expect_true(TRUE)
})
