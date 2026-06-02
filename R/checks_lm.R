#' Check Variance Inflation Factors
#'
#' Computes variance inflation factors to detect multicollinearity.
#'
#' @param model A fitted model object.
#' @return A list describing whether VIF computation succeeded. Successful
#'   results include a `vif` element containing the variance inflation factors.
#' @export
#' @examples
#' model <- lm(mpg ~ wt + hp + disp, data = mtcars)
#' check_vif(model)
check_vif <- function(model) {

  if (inherits(model, "coxph")) {
    return(list(
      success = FALSE,
      message = "VIF not applicable to Cox models (no intercept)."
    ))
  }

  tryCatch({
    result <- suppressWarnings(car::vif(model))

    vif_values <- if (is.matrix(result)) {
      if ("GVIF" %in% colnames(result)) {
        result[, "GVIF"]
      } else {
        result[, 1]
      }
    } else {
      result
    }

    severity_label <- function(v) {
      if (is.na(v)) return(NA_character_)
      if (v < 2) return("Negligible")
      if (v < 5) return("Moderate")
      if (v < 10) return("High")
      return("Severe")
    }

    severities <- if (length(vif_values) > 0 && is.numeric(vif_values)) {
      vapply(vif_values, severity_label, FUN.VALUE = character(1), USE.NAMES = TRUE)
    } else {
      character(0)
    }

    collinear_predictors <- if (length(vif_values) > 0 && any(vif_values >= 10, na.rm = TRUE)) {
      names(vif_values)[which(vif_values >= 10)]
    } else {
      character(0)
    }

    predictors_with_severity <- if (length(vif_values) > 0) {
      paste0(names(vif_values), " (", severities, ")")
    } else {
      character(0)
    }

    note <- if (length(predictors_with_severity) > 0) {
      paste("VIF severity by predictor:", paste(predictors_with_severity, collapse = ", "))
    } else {
      "VIF could not be computed or no predictors available."
    }

    list(
      success = TRUE,
      vif = result,
      note = note,
      collinear_predictors = collinear_predictors,
      severities = severities
    )

  }, warning = function(w) {
    list(
      success = FALSE,
      message = conditionMessage(w)
    )

  }, error = function(e) {
    list(
      success = FALSE,
      message = "VIF could not be computed",
      error = e$message
    )
  })
}




#' Check Heteroskedasticity
#'
#' Performs Breusch-Pagan test for heteroskedasticity.
#'
#' @param model A fitted lm object.
#' @return An htest object or NA if computation fails.
#' @export
#' @examples
#' model <- lm(mpg ~ wt + hp, data = mtcars)
#' check_heteroskedasticity(model)
check_heteroskedasticity <- function(model) {
  if (!inherits(model, "lm")) return(NA)

  tryCatch({
    suppressWarnings(lmtest::bptest(model))
  }, warning = function(e) {
    NA
  }, error = function(e) {
    NA
  })
}

#' Check Autocorrelation
#'
#' Performs the Durbin-Watson test for first-order autocorrelation in residuals.
#'
#' @param model A fitted lm object.
#' @return An htest object or NA if computation fails.
#' @export
#' @examples
#' model <- lm(mpg ~ wt + hp, data = mtcars)
#' check_autocorrelation(model)
check_autocorrelation <- function(model) {
  if (!inherits(model, "lm")) return(NA)

  tryCatch({
    suppressWarnings(lmtest::dwtest(model))
  }, warning = function(e) {
    NA
  }, error = function(e) {
    NA
  })
}

#' Check Linearity
#'
#' Performs Ramsey's RESET test for linear model misspecification.
#'
#' @param model A fitted lm object.
#' @param power Powers of fitted values to include in the test.
#' @return An htest object with an added note, or NA if computation fails.
#' @export
#' @examples
#' model <- lm(mpg ~ wt + hp, data = mtcars)
#' check_linearity(model)
check_linearity <- function(model, power = 2) {
  if (!inherits(model, "lm")) return(NA)

  tryCatch({
    result <- suppressWarnings(lmtest::resettest(model, power = power, type = "fitted"))
    if (inherits(result, "htest")) {
      result$note <- if (result$p.value <= 0.05) {
        "Evidence against linearity in the model; consider adding nonlinear terms or transformations."
      } else {
        "No evidence against linearity in the model; the linear functional form appears reasonable."
      }
    }
    result
  }, warning = function(e) {
    NA
  }, error = function(e) {
    NA
  })
}

#' Check Normality of Residuals
#'
#' Performs the Shapiro-Wilk test on model residuals.
#'
#' @param model A fitted model object.
#' @return An htest object or NA if computation fails.
#' @export
#' @examples
#' model <- lm(mpg ~ wt + hp, data = mtcars)
#' check_normality(model)
check_normality <- function(model) {
  res <- residuals(model)
  tryCatch({
    shapiro.test(res)
  }, error = function(e) {
    NA
  })
}

#' Check Influential Observations
#'
#' Identifies influential observations using Cook's distance.
#'
#' @param model A fitted model object.
#' @param cutoff Cook's distance cutoff. Defaults to 4 divided by the number of
#'   observations.
#' @return A list containing Cook's distances and influential point indices.
#' @export
#' @examples
#' model <- lm(mpg ~ wt + hp, data = mtcars)
#' check_outliers(model)
check_outliers <- function(model, cutoff = 4 / length(residuals(model))) {
  cooks <- cooks.distance(model)
  if(!is.null(cutoff)) {
    influential <- which(cooks > cutoff)
  } else {
  influential <- which(cooks > (4 / length(cooks)))
  }
  list(
    cooks_distance = cooks,
    influential_points = influential
  )
}

#' Check Logistic Linearity with Box-Tidwell Test
#'
#' Performs a Box-Tidwell test for linearity of continuous predictors in the
#' logit.
#'
#' @param model A fitted glm object.
#' @return A Box-Tidwell test result or NA if computation fails.
#' @export
#' @examples
#' model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
#' check_box_tidwell(model)
check_box_tidwell <- function(model) {
  tryCatch({
    car::boxTidwell(model$formula, data = model$data)
  }, error = function(e) {
    NA
  })
}

#' Check Logistic Goodness of Fit
#'
#' Performs the Hosmer-Lemeshow goodness-of-fit test for binomial glm models.
#'
#' @param model A fitted binomial glm object.
#' @return An htest object or NA if computation fails or the model is not
#'   binomial.
#' @export
#' @examples
#' model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
#' check_hosmer_lemeshow(model)
check_hosmer_lemeshow <- function(model) {
  if (!inherits(model, "glm") || model$family$family != "binomial") {
    return(NA)
  }

  tryCatch({
    n <- length(model$y)
    g <- min(10, floor(n / 5)) 
    suppressWarnings(
      ResourceSelection::hoslem.test(model$y, fitted(model), g = g)
    )

  }, warning = function(e) {
    NA
  }, error = function(e) {
    NA
  })
}

#' Check Influential Observations in GLMs
#'
#' Identifies influential observations in generalized linear models using
#' Cook's distance.
#'
#' @param model A fitted glm object.
#' @return A list containing Cook's distances and influential point indices.
#' @export
#' @examples
#' model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
#' check_influential_glm(model)
check_influential_glm <- function(model) {
  cooks <- cooks.distance(model)
  influential <- which(cooks > (4 / length(cooks)))

  list(
    cooks_distance = cooks,
    influential_points = influential
  )
}

#' Check Separation in GLMs
#'
#' Checks for simple indicators of complete or quasi-complete separation.
#'
#' @param model A fitted glm object.
#' @return A character message describing whether separation was detected, or NA
#'   if the model is not a glm.
#' @export
#' @examples
#' model <- glm(am ~ wt + hp, data = mtcars, family = binomial)
#' check_separation(model)
check_separation <- function(model) {
  if (!inherits(model, "glm")) return(NA)

  coefs <- coef(model)

  if (any(is.infinite(coefs)) || any(is.na(coefs))) {
    return("Separation detected: coefficients are infinite or NA.")
  }

  if (!isTRUE(model$converged)) {
    return("Model did not converge (possible separation).")
  }

  "No separation issues detected."
}

#' Check Overdispersion
#'
#' Checks whether a Poisson glm appears overdispersed using the residual
#' deviance to degrees-of-freedom ratio.
#'
#' @param model A fitted Poisson glm object.
#' @return A list with overdispersion diagnostics, or NA if the model is not
#'   Poisson or computation fails.
#' @export
#' @examples
#' model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
#' check_overdispersion(model)
check_overdispersion <- function(model) {
  if (model$family$family != "poisson") {
    return(NA)
  }
  tryCatch({
    dev <- deviance(model)
    df <- df.residual(model)
    ratio <- dev / df
    list(
      residual_deviance = dev,
      df = df,
      ratio = ratio,
      overdispersed = ratio > 1.5  # threshold
    )
  }, error = function(e) {
    NA
  })
}

#' Check Zero Inflation
#'
#' Compares observed zeros with the number expected under a fitted Poisson glm.
#'
#' @param model A fitted Poisson glm object.
#' @return A list with zero-inflation diagnostics, or NA if the model is not
#'   Poisson or computation fails.
#' @export
#' @examples
#' model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
#' check_zero_inflation(model)
check_zero_inflation <- function(model) {
  if (model$family$family != "poisson") {
    return(NA)
  }
  tryCatch({
    y <- model$y
    mu <- fitted(model)
    expected_zeros <- sum(dpois(0, mu))
    observed_zeros <- sum(y == 0)
    n <- length(y)
    prop_expected <- expected_zeros / n
    prop_observed <- observed_zeros / n
    list(
      observed_zeros = observed_zeros,
      expected_zeros = expected_zeros,
      prop_observed = prop_observed,
      prop_expected = prop_expected,
      zero_inflated = prop_observed > prop_expected * 1.5  # rough threshold
    )
  }, error = function(e) {
    NA
  })
}

#' Check Residual Summary
#'
#' Summarizes deviance residuals for a generalized linear model.
#'
#' @param model A fitted model object.
#' @return A list of residual summary statistics, or NA if computation fails.
#' @export
#' @examples
#' model <- glm(carb ~ wt + hp, data = mtcars, family = poisson)
#' check_residual_analysis(model)
check_residual_analysis <- function(model) {
  tryCatch({
    res <- residuals(model, type = "deviance")
    list(
      mean_residual = mean(res),
      sd_residual = sd(res),
      min_residual = min(res),
      max_residual = max(res)
    )
  }, error = function(e) {
    NA
  })
}

#' Check Proportional Hazards
#'
#' Performs a proportional hazards test for a fitted Cox model using Schoenfeld
#' residuals.
#'
#' @param model A fitted coxph object.
#' @return A cox.zph result or NA if computation fails.
#' @export
#' @examples
#' if (requireNamespace("survival", quietly = TRUE)) {
#'   model <- survival::coxph(
#'     survival::Surv(time, status) ~ age + sex,
#'     data = survival::lung
#'   )
#'   check_proportional_hazards(model)
#' }
check_proportional_hazards <- function(model) {
  tryCatch({
    survival::cox.zph(model)
  }, error = function(e) {
    NA
  })
}

#' Check Influential Observations in Cox Models
#'
#' Identifies influential observations in Cox models using dfbeta residuals.
#'
#' @param model A fitted coxph object.
#' @return A list containing dfbeta residuals and influential point indices, or
#'   NA if computation fails.
#' @export
#' @examples
#' if (requireNamespace("survival", quietly = TRUE)) {
#'   model <- survival::coxph(
#'     survival::Surv(time, status) ~ age + sex,
#'     data = survival::lung
#'   )
#'   check_influential_coxph(model)
#' }
check_influential_coxph <- function(model) {
  tryCatch({
    dfb <- residuals(model, type = "dfbetas")
    influential <- which(apply(abs(dfb), 1, max) > 0.2)
    list(
      dfbetas = dfb,
      influential_points = influential
    )
  }, error = function(e) {
    NA
  })
}

#' Check Cox Model Functional Form
#'
#' Provides guidance for checking nonlinear functional form in Cox models using
#' martingale residuals.
#'
#' @param model A fitted coxph object.
#' @return A character message or NA if computation fails.
#' @export
#' @examples
#' if (requireNamespace("survival", quietly = TRUE)) {
#'   model <- survival::coxph(
#'     survival::Surv(time, status) ~ age + sex,
#'     data = survival::lung
#'   )
#'   check_functional_form_coxph(model)
#' }
check_functional_form_coxph <- function(model) {
  tryCatch({
    mart <- residuals(model, type = "martingale")
    "Functional form check: Review plots of martingale residuals vs predictors for nonlinearity."
  }, error = function(e) {
    NA
  })
}
