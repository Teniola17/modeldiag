---
title: 'modeldiag: A Unified Framework for Comprehensive Diagnostics of Statistical Models in R'
tags:
  - R
  - statistics
  - linear regression
  - logistic regression
  - Poisson regression
  - survival analysis
  - model diagnostics
authors:
  - name: Emmanuel Adewuyi
    orcid: 0000-0002-7920-6866
    corresponding: true
    affiliation: 1
  - name: Adewale Lukman
    orcid: 0000-0003-2881-1297
    affiliation: 2
  - name: Abiola Owolabi
    orcid: 0000-0001-9843-5085
    affiliation: 3
affiliations:
  - name: London School of Hygiene and Tropical Medicine, United Kingdom
    index: 1
  - name: University of North Dakota, United States of America
    index: 2
  - name: Ladoke Akintola University of Technology, Nigeria
    index: 3
date: xx xx xx
bibliography: paper.bib
---

# Summary

In statistical analysis, model checking is a fundamental step. The consistency of
statistical inference depends not only on the validity of parameter estimates but also
requires that all essential model assumptions hold. However, existing model diagnostic
tools in R are spread across multiple independent packages, with distinct syntax, output
formats, and documentation. This leads to a large burden in regression diagnostic checking.
To tackle this issue, we developed the `modeldiag` package [@rcore2024]. This package
supports linear models, generalized linear models (logistic regression, Poisson regression),
and Cox proportional hazards models, and provides a unified regression diagnostic framework
to examine linearity, multicollinearity, heteroscedasticity, autocorrelation, non-normality,
influential observations, and other related model assumptions. The package returns both
text-based summaries and diagnostic plots, providing a practical balance between numerical
assessment and visual interpretation.

# Statement of Need

Model diagnosis is a key factor in model building. Currently, in mainstream statistical
modeling using R, the available model diagnosis tools are generally disseminated across
multiple independent third-party packages. When performing analyses, practitioners often
need to call functions from different packages to complete various diagnostic tasks: they
utilize the `car` package [@fox2019] for collinearity testing, the `lmtest` package
[@zeileis2002] to evaluate model assumptions, the `ResourceSelection` package [@lele2019]
to perform goodness-of-fit tests for logistic regression, and the `survival` package
[@therneau2000] to implement Cox regression diagnostics. It is undisputable that all these
existing tools are mature and reliable, but their diagnostic functions have not been
incorporated into a unified, coherent workflow. Users must piece together the dedicated
commands of multiple packages to complete routine diagnostic checks that should otherwise
be standardized. The `modeldiag` package was developed to address this gap by bringing
key regression diagnostic tools together within a single, unified framework. The package
targets practicing statisticians, epidemiologists, biostatisticians, and data scientists
who need to validate model assumptions efficiently within a reproducible workflow.

# State of the Field

Several R packages address portions of the model-diagnostics problem. The `performance`
package [@ludecke2021] provides a `check_model()` function with visual output for linear,
generalised linear, and mixed-effects models, yet it diverges from `modeldiag` in terms of
its design, output format, and dependency structure, and does not offer the full suite of
GLM-specific diagnostics such as the Hosmer–Lemeshow goodness-of-fit test or zero-inflation
detection. The `car` package [@fox2019] provides generalised VIF computation but is not
designed as a stand-alone, model-class-aware diagnostic workflow. The `lmtest` package
[@zeileis2002] covers specification tests such as linearity, non-constant variance, and
autocorrelation for linear models, but does not extend to GLM or Cox model families.

The `modeldiag` package is not a replacement for these existing packages but provides a
single unified framework for all these regression diagnostic tools across linear models,
generalized linear models, and Cox regression models. No existing package provides a single
`diagnose_model()` entry point covering all four model classes (`lm`, `glm` with binomial
and Poisson families, and `coxph`) with a fully consistent interface. Furthermore,
`modeldiag` couples test execution with structured text interpretation in its `summary()`
method, making diagnostic output accessible to analysts who may not be familiar with the
numerical output of individual test functions.

# Software Design

`modeldiag` implements an S3 dispatch system around a single generic function,
`diagnose_model()`, which branches to `diagnose_model.lm()`, `diagnose_model.glm()`, and
`diagnose_model.coxph()` based on the class attribute of the fitted model. Each method
executes the appropriate `check_*()` functions and returns a named list of class
`"model_diagnostics"` containing the model type, the original model object, and all
diagnostic results. The `print()`, `summary()`, and `plot()` S3 methods dispatch on this
class to deliver formatted output and publication-quality graphics.

The exported `check_*()` functions can also be called independently, enabling targeted,
reproducible diagnostic workflows. Table 1 summarizes the principal diagnostic functions
and the model classes for which they are available.

**Table 1:** Core diagnostic functions in `modeldiag`.

| Function | Diagnostic | Model | Method |
|---|---|---|---|
| `diagnose_model()` | Overall diagnosis | LM, GLM, Cox | Combined Report |
| `check_vif()` | VIF / GVIF | LM, GLM | Fox & Monette (1992) |
| `check_heteroscedasticity()` | Breusch–Pagan | LM | Breusch & Pagan (1979) |
| `check_autocorrelation()` | Durbin–Watson | LM | Durbin & Watson (1950) |
| `check_normality()` | Shapiro–Wilk | LM | Shapiro & Wilk (1965) |
| `check_influential()` | Cook's distance | LM, GLM | Cook (1977) |
| `check_linearity()` | Ramsey's RESET | LM | Ramsey, J.B. (1969) |
| `check_overdispersion()` | Score test | Poisson GLM | Dean & Lawless (1989) |
| `check_zeroinflation()` | Zero count ratio | Count GLM | — |
| `check_goodnessoffit()` | Hosmer–Lemeshow | Logistic GLM | Hosmer & Lemeshow |
| `check_proportionalhazards()` | Schoenfeld test | Cox (survival) | Grambsch & Therneau (1994) |
| `plot_diagnostics()` | Visual diagnostics | LM, GLM, Cox | — |

The package imports `car` [@fox2019], `lmtest` [@zeileis2002], `ResourceSelection`
[@lele2019], and `survival` [@therneau2000] for the underlying test computations, and
depends on base R `stats` and `graphics` for all other operations.

# Mathematics

## Linear Models

For a linear model $\mathbf{y} = \mathbf{X}\boldsymbol{\beta} + \boldsymbol{\varepsilon}$,
where $\boldsymbol{\varepsilon} \sim \mathcal{N}(\mathbf{0}, \sigma^2 I)$, `modeldiag`
provides the following diagnostics.

**Multicollinearity.** Multicollinearity inflates the variance of ordinary least-squares
(OLS) estimators. The Variance Inflation Factor (VIF) for predictor $j$ quantifies this
inflation [@fox1992]:

$$\mathrm{VIF}_j = \frac{1}{1 - R^2_j},$$

where $R^2_j$ is the coefficient of determination from regressing $X_j$ on all remaining
predictors. A $\mathrm{VIF}_j > 10$ is commonly taken as evidence of problematic
collinearity. For models with categorical predictors, `modeldiag` computes the Generalised
VIF [@fox1992], which adjusts for the degrees of freedom associated with multi-level factors.

**Heteroscedasticity.** The Breusch–Pagan test [@breusch1979] assesses whether the
residual variance is constant (homoscedastic). Squared OLS residuals $\hat{\varepsilon}_i^2$
are regressed on the original predictors:

$$\hat{\varepsilon}_i^2 = \gamma_0 + \gamma_1 x_{i1} + \cdots + \gamma_p x_{ip} + u_i.$$

The test statistic is $\mathrm{BP} = nR^2_{\text{aux}}$, where $R^2_{\text{aux}}$ is from
this auxiliary regression. Under $H_0$ (homoscedasticity),
$\mathrm{BP} \sim \chi^2_p$ asymptotically.

**Autocorrelation.** The Durbin–Watson test detects first-order autocorrelation in
residuals. There is no autocorrelation when the statistic is approximately 2; values
significantly lower or higher than 2 indicate positive or negative autocorrelation,
respectively.

**Normality of errors.** The Shapiro–Wilk test evaluates whether model residuals are
normally distributed. The error term is normally distributed when the p-value exceeds the
chosen significance level.

**Influential observations.** Cook's distance [@cook1977] measures the aggregate shift in
$\hat{\boldsymbol{\beta}}$ upon deletion of observation $i$:

$$D_i = \frac{\left(\hat{\boldsymbol{\beta}} - \hat{\boldsymbol{\beta}}_{(i)}\right)^\top X^\top X \left(\hat{\boldsymbol{\beta}} - \hat{\boldsymbol{\beta}}_{(i)}\right)}{p\,\hat{\sigma}^2}.$$

Observations with relatively large Cook's distance values may warrant further investigation,
although commonly used cutoff values are intended as practical guidelines rather than strict
criteria.

## Logistic Regression

For binary-response models, `modeldiag` provides the following diagnostics.

**Goodness of fit.** The Hosmer–Lemeshow test [@hosmer2013] partitions observations into
groups based on estimated probabilities and computes:

$$\hat{C} = \sum_{k=1}^{g} \frac{(O_k - E_k)^2}{E_k(1 - E_k/n_k)},$$

where $O_k$ and $E_k$ are observed and expected event counts in group $k$. The resulting
statistic is referred to an approximate $\chi^2_{g-2}$ distribution, where $g$ is the
number of groups. This diagnostic is implemented through the `ResourceSelection` package
[@lele2019].

## Poisson Regression

**Overdispersion.** The package tests whether a Poisson model meets the mean-variance
constraint $\mathrm{Var}(Y_i) = \mu_i$. The score technique proposed by @dean1989 is
adopted to diagnose deviations from this constraint. If a model suffers from overdispersion,
it will produce underestimated standard errors, leading to spuriously inflated confidence in
statistical inferences. This issue can be addressed by adopting alternative models such as
the Quasi-Poisson or negative binomial regression model.

**Zero inflation.** Zero inflation is examined by comparing the observed frequency of zero
responses with the frequency expected under the fitted model. For a Poisson mean
$\hat{\mu}_i$, these quantities are:

$$\hat{p}_0^{\mathrm{obs}} = \frac{1}{n}\sum_{i=1}^n \mathbf{1}(y_i=0), \qquad \hat{p}_0^{\mathrm{exp}} = \frac{1}{n}\sum_{i=1}^n \exp(-\hat{\mu}_i).$$

Large discrepancies between the two provide evidence that the fitted count model does not
adequately account for excess zeros.

## Cox Proportional Hazards Model

**Proportional hazards assumption.** `modeldiag` uses Schoenfeld-residual diagnostics to
assess time variation in covariate effects [@grambsch1994]. The scaled Schoenfeld residuals
are examined for association with time; systematic trends provide evidence against the
proportional hazards assumption. This is implemented through `survival::cox.zph()`.

# Usage

## Linear Models

```r
library(modeldiag)

fit_lm  <- lm(mpg ~ wt + hp + cyl, data = mtcars)
diag_lm <- diagnose_model(fit_lm)
summary(diag_lm)
```

Individual checks are also available for targeted analysis:

```r
check_vif(fit_lm)
check_heteroscedasticity(fit_lm)
check_autocorrelation(fit_lm)
check_normality(fit_lm)
check_influential(fit_lm)
plot_diagnostics(fit_lm)
```

## Logistic Regression

```r
fit_glm  <- glm(am ~ wt + hp, data = mtcars, family = binomial)
diag_glm <- diagnose_model(fit_glm)
summary(diag_glm)
```

Individual logistic regression diagnostics:

```r
check_vif(fit_glm)
check_goodnessoffit(fit_glm)
check_influential(fit_glm)
```

## Poisson Regression

```r
fit_pois  <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
diag_pois <- diagnose_model(fit_pois)
summary(diag_pois)
```

Individual Poisson diagnostics:

```r
check_vif(fit_pois)
check_overdispersion(fit_pois)
check_zeroinflation(fit_pois)
```

## Cox Proportional Hazards Model

```r
library(survival)

fit_cox  <- coxph(Surv(time, status) ~ age + sex, data = lung)
diag_cox <- diagnose_model(fit_cox)
summary(diag_cox)
```

Individual Cox model diagnostics:

```r
check_proportionalhazards(fit_cox)
```

# AI Usage Disclosure

Claude Code (Anthropic) was used during software development to assist with refactoring R code, improving function documentation, identifying potential implementation issues, and suggesting code organization improvements. Claude Code was also used during manuscript preparation to improve grammar, readability, and overall presentation of the text.

The underlying statistical methodology, package architecture, simulation study design, implementation decisions, analyses and interpretation of findings were developed and validated by the authors. AI-generated suggestions were treated as advisory only and were independently reviewed, tested, and verified before adoption.

The authors retain full responsibility for the software, manuscript, and all reported results.

# Acknowledgements

We acknowledge the developers and maintainers of the `car` [@fox2019], `lmtest`
[@zeileis2002], `ResourceSelection` [@lele2019], and `survival` [@therneau2000] packages.
Several diagnostic routines in `modeldiag` build on the methods and software infrastructure
made available through these packages.

# References
