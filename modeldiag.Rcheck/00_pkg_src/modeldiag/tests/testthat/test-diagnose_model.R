test_that("diagnose_model works for lm", {
  model <- lm(mpg ~ wt + hp, data = mtcars)
  diag <- diagnose_model(model)
  expect_s3_class(diag, "model_diagnostics")
  expect_equal(diag$model_type, "lm")
  expect_true("multicollinearity" %in% names(diag$tests))
  expect_true("heteroskedasticity" %in% names(diag$tests))
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
  library(survival)
  data(lung)
  model <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lung)
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
  expect_output(summary(diag), "Model Diagnostics Summary")
})

test_that("plot method works without error", {
  model <- lm(mpg ~ wt, data = mtcars)
  diag <- diagnose_model(model)
  expect_silent(plot(diag))
})