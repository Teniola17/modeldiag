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

## ----linear-individual-checks-------------------------------------------------
check_vif(model_lm)
check_heteroskedasticity(model_lm)
check_autocorrelation(model_lm)
check_linearity(model_lm)
check_normality(model_lm)
check_outliers(model_lm)

## ----logistic-example---------------------------------------------------------
model_glm <- glm(am ~ wt + hp, data = mtcars, family = binomial)
diag_glm <- diagnose_model(model_glm)
summary(diag_glm)

## ----logistic-individual-checks-----------------------------------------------
check_box_tidwell(model_glm)
check_hosmer_lemeshow(model_glm)
check_influential_glm(model_glm)
check_separation(model_glm)

## ----poisson-example----------------------------------------------------------
model_pois <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
diag_pois <- diagnose_model(model_pois)
summary(diag_pois)

## ----poisson-individual-checks------------------------------------------------
check_overdispersion(model_pois)
check_zero_inflation(model_pois)
check_residual_analysis(model_pois)

## ----survival-example---------------------------------------------------------
library(survival)
data(lung)

model_cox <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lung)
diag_cox <- diagnose_model(model_cox)
summary(diag_cox)

## ----survival-individual-checks-----------------------------------------------
check_proportional_hazards(model_cox)
check_influential_coxph(model_cox)
check_functional_form_coxph(model_cox)

## ----plotting, fig.height=6, fig.width=6--------------------------------------
plot(diag_lm)


