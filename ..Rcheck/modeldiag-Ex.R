pkgname <- "modeldiag"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
base::assign(".ExTimings", "modeldiag-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('modeldiag')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("check_autocorrelation")
### * check_autocorrelation

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_autocorrelation
### Title: Check Autocorrelation
### Aliases: check_autocorrelation

### ** Examples

model <- lm(mpg ~ wt + hp, data = mtcars)
check_autocorrelation(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_autocorrelation", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_box_tidwell")
### * check_box_tidwell

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_box_tidwell
### Title: Check Logistic Linearity with Box-Tidwell Test
### Aliases: check_box_tidwell

### ** Examples

model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_box_tidwell(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_box_tidwell", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_functional_form_coxph")
### * check_functional_form_coxph

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_functional_form_coxph
### Title: Check Cox Model Functional Form
### Aliases: check_functional_form_coxph

### ** Examples

if (requireNamespace("survival", quietly = TRUE)) {
  model <- survival::coxph(
    survival::Surv(time, status) ~ age + sex,
    data = survival::lung
  )
  check_functional_form_coxph(model)
}



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_functional_form_coxph", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_heteroskedasticity")
### * check_heteroskedasticity

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_heteroskedasticity
### Title: Check Heteroskedasticity
### Aliases: check_heteroskedasticity

### ** Examples

model <- lm(mpg ~ wt + hp, data = mtcars)
check_heteroskedasticity(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_heteroskedasticity", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_hosmer_lemeshow")
### * check_hosmer_lemeshow

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_hosmer_lemeshow
### Title: Check Logistic Goodness of Fit
### Aliases: check_hosmer_lemeshow

### ** Examples

model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_hosmer_lemeshow(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_hosmer_lemeshow", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_influential_coxph")
### * check_influential_coxph

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_influential_coxph
### Title: Check Influential Observations in Cox Models
### Aliases: check_influential_coxph

### ** Examples

if (requireNamespace("survival", quietly = TRUE)) {
  model <- survival::coxph(
    survival::Surv(time, status) ~ age + sex,
    data = survival::lung
  )
  check_influential_coxph(model)
}



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_influential_coxph", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_influential_glm")
### * check_influential_glm

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_influential_glm
### Title: Check Influential Observations in GLMs
### Aliases: check_influential_glm

### ** Examples

model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_influential_glm(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_influential_glm", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_linearity")
### * check_linearity

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_linearity
### Title: Check Linearity
### Aliases: check_linearity

### ** Examples

model <- lm(mpg ~ wt + hp, data = mtcars)
check_linearity(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_linearity", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_normality")
### * check_normality

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_normality
### Title: Check Normality of Residuals
### Aliases: check_normality

### ** Examples

model <- lm(mpg ~ wt + hp, data = mtcars)
check_normality(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_normality", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_outliers")
### * check_outliers

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_outliers
### Title: Check Influential Observations
### Aliases: check_outliers

### ** Examples

model <- lm(mpg ~ wt + hp, data = mtcars)
check_outliers(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_outliers", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_overdispersion")
### * check_overdispersion

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_overdispersion
### Title: Check Overdispersion
### Aliases: check_overdispersion

### ** Examples

model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
check_overdispersion(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_overdispersion", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_proportional_hazards")
### * check_proportional_hazards

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_proportional_hazards
### Title: Check Proportional Hazards
### Aliases: check_proportional_hazards

### ** Examples

if (requireNamespace("survival", quietly = TRUE)) {
  model <- survival::coxph(
    survival::Surv(time, status) ~ age + sex,
    data = survival::lung
  )
  check_proportional_hazards(model)
}



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_proportional_hazards", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_residual_analysis")
### * check_residual_analysis

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_residual_analysis
### Title: Check Residual Summary
### Aliases: check_residual_analysis

### ** Examples

model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
check_residual_analysis(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_residual_analysis", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_separation")
### * check_separation

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_separation
### Title: Check Separation in GLMs
### Aliases: check_separation

### ** Examples

model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
check_separation(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_separation", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_vif")
### * check_vif

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_vif
### Title: Check Variance Inflation Factors
### Aliases: check_vif

### ** Examples

model <- lm(mpg ~ wt + hp + disp, data = mtcars)
check_vif(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_vif", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("check_zero_inflation")
### * check_zero_inflation

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: check_zero_inflation
### Title: Check Zero Inflation
### Aliases: check_zero_inflation

### ** Examples

model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
check_zero_inflation(model)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("check_zero_inflation", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("diagnose_model")
### * diagnose_model

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
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



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("diagnose_model", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
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
