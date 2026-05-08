## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(modeldiag)

## ----linear-example-----------------------------------------------------------
model_lm <- lm(mpg ~ wt + hp + disp, data = mtcars)
diag_lm <- diagnose_model(model_lm)
summary(diag_lm)

## ----logistic-example---------------------------------------------------------
model_glm <- glm(am ~ wt + hp, data = mtcars, family = binomial)
diag_glm <- diagnose_model(model_glm)
summary(diag_glm)

## ----poisson-example----------------------------------------------------------
model_pois <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
diag_pois <- diagnose_model(model_pois)
summary(diag_pois)

## ----survival-example---------------------------------------------------------
library(survival)
data(lung)

model_cox <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lung)
diag_cox <- diagnose_model(model_cox)
summary(diag_cox)

## ----plotting, fig.height=6, fig.width=6--------------------------------------
old_par <- par(no.readonly = TRUE)
on.exit(par(old_par), add = TRUE)
par(mfrow = c(2, 2))
plot(diag_lm)


