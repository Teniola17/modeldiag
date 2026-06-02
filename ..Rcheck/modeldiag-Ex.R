pkgname <- "modeldiag"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('modeldiag')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("diagnose_model")
### * diagnose_model

flush(stderr()); flush(stdout())

### Name: diagnose_model.glm
### Title: Diagnose Statistical Models
### Aliases: diagnose_model.glm diagnose_model.lm diagnose_model.coxph
###   diagnose_model

### ** Examples

# Linear model diagnostics
model_lm <- lm(mpg ~ wt + hp, data = mtcars)
diag_lm <- diagnose_model(model_lm)
summary(diag_lm)
plot(diag_lm)

# Logistic regression diagnostics
model_glm <- glm(am ~ wt + hp, data = mtcars, family = binomial)
diag_glm <- diagnose_model(model_glm)
summary(diag_glm)

# Poisson regression diagnostics
model_pois <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
diag_pois <- diagnose_model(model_pois)
summary(diag_pois)

# Cox proportional hazards diagnostics
library(survival)
data(lung)
model_cox <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lung)
diag_cox <- diagnose_model(model_cox)
summary(diag_cox)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
