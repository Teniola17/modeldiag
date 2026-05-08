interpret_diagnostic <- function(test_name, result) {
  if (is.na(result)) {
    return("Interpretation unavailable due to missing test result.")
  }

  if (test_name == "multicollinearity") {
    if (result <= 0.05) {
      return("Some predictors may be collinear; review variance inflation factors.")
    }
    return("No strong evidence of problematic multicollinearity.")
  }

  if (test_name == "heteroskedasticity") {
    if (result <= 0.05) {
      return("Heteroskedasticity is likely present; standard errors may be unreliable.")
    }
    return("Residual variance appears approximately constant.")
  }

  if (test_name == "autocorrelation") {
    if (result <= 0.05) {
      return("Residuals appear autocorrelated; consider time-series adjustments.")
    }
    return("No meaningful evidence of residual autocorrelation.")
  }

  if (test_name == "normality") {
    if (result <= 0.05) {
      return("Residuals deviate from normality; check model assumptions.")
    }
    return("Residuals are consistent with normality.")
  }

  if (test_name == "linearity_logit") {
    if (result <= 0.05) {
      return("Linearity of logit assumption may be violated; consider transformations.")
    }
    return("Linearity of logit appears reasonable.")
  }

  if (test_name == "goodness_of_fit") {
    if (result <= 0.05) {
      return("Model fit is poor; consider model revisions.")
    }
    return("Model fit appears adequate.")
  }

  if (test_name == "proportional_hazards") {
    # For cox.zph, p_value is for the global test or per variable
    # Assuming global
    if (result <= 0.05) {
      return("Proportional hazards assumption may be violated; consider time-varying effects.")
    }
    return("Proportional hazards assumption appears reasonable.")
  }

  if (test_name == "overdispersion") {
    if (is.list(result) && !is.null(result$ratio)) {
      if (result$overdispersed) {
        return("Overdispersion detected; consider negative binomial or quasipoisson model.")
      }
      return("No evidence of overdispersion.")
    }
    return("Overdispersion check unavailable.")
  }

  if (test_name == "zero_inflation") {
    if (is.list(result) && !is.null(result$prop_observed)) {
      if (result$zero_inflated) {
        return("Zero-inflation detected; consider zero-inflated Poisson or hurdle models.")
      }
      return("No evidence of zero-inflation.")
    }
    return("Zero-inflation check unavailable.")
  }

  "No interpretation available for this diagnostic."
}

interpret_outliers <- function(outlier_result) {
  if (!is.list(outlier_result) || is.null(outlier_result$cooks_distance)) {
    return("Outlier diagnostics are unavailable for this model.")
  }

  count <- length(outlier_result$influential_points)
  guide <- "Influential observations have Cook's distance above 4/n. Review these cases for leverage, data entry issues, or model fit problems."

  if (count == 0) {
    return(paste("No influential observations detected.", guide))
  }

  paste(count, "influential observation(s) detected.", guide)
}

#' Summarize Model Diagnostics
#'
#' Provides a detailed summary of diagnostic test results.
#'
#' @param object An object of class "model_diagnostics".
#' @param ... Additional arguments (currently ignored).
#' @return The object, invisibly.
#' @method summary model_diagnostics
#' @export
summary.model_diagnostics <- function(object, ...) {

  cat("Model Diagnostics Summary\n")
  cat("=========================\n\n")

  for (name in names(object$tests)) {
    cat("----", name, "----\n")

    result <- object$tests[[name]]

    if (inherits(result, "htest")) {
      cat("p-value:", result$p.value, "\n")
      cat(interpret_diagnostic(name, result$p.value), "\n\n")
    } else if (name == "multicollinearity" && is.numeric(result)) {
      cat("Variance inflation factors:\n")
      print(result)
      if (all(result < 5, na.rm = TRUE)) {
        cat("VIFs are acceptable; no serious multicollinearity detected.\n\n")
      } else if (any(result > 10, na.rm = TRUE)) {
        cat("Some predictors show high VIF; multicollinearity may be problematic.\n\n")
      } else {
        cat("Some predictors show moderate VIF; monitor model stability.\n\n")
      }
    } else if (name == "outliers" || name == "influential_observations") {
      if (is.list(result)) {
        if (!is.null(result$dfbetas)) {
          # For coxph
          cat("Number of influential points:", length(result$influential_points), "\n")
          if (length(result$influential_points) > 0) {
            cat("Influential observations:", paste(result$influential_points, collapse = ", "), "\n")
            cat("Max |dfbeta| for influential observations:\n")
            max_dfb <- apply(abs(result$dfbetas[result$influential_points, , drop = FALSE]), 1, max)
            print(max_dfb)
          } else {
            cat("No observations exceed the influence threshold.\n")
          }
          cat("Influential observations have |dfbeta| > 0.2 for at least one coefficient. Review these cases.\n\n")
        } else if (!is.null(result$cooks_distance)) {
          cat("Number of influential points:", length(result$influential_points), "\n")
          if (length(result$influential_points) > 0) {
            influential_names <- names(result$influential_points)
            if (is.null(influential_names)) {
              influential_names <- result$influential_points
            }
            cat("Influential observations:", paste(influential_names, collapse = ", "), "\n")
            cat("Cook's distances for influential observations:\n")
            print(result$cooks_distance[result$influential_points])
          } else {
            cat("No observations exceed the influence threshold.\n")
          }
          cat(interpret_outliers(result), "\n\n")
        } else {
          print(result)
          cat("\n")
        }
      } else {
        print(result)
        cat("\n")
      }
    } else if (name == "separation_issues") {
      cat(result, "\n\n")
    } else if (name == "proportional_hazards") {
      if (inherits(result, "cox.zph")) {
        cat("Global test p-value:", result$table[nrow(result$table), "p"], "\n")
        print(result$table)
        p_val <- result$table[nrow(result$table), "p"]
        cat(interpret_diagnostic(name, p_val), "\n\n")
      } else {
        print(result)
        cat("\n")
      }
    } else if (name == "functional_form") {
      cat(result, "\n\n")
    } else if (name == "overdispersion") {
      if (is.list(result)) {
        cat("Residual deviance:", result$residual_deviance, "\n")
        cat("Degrees of freedom:", result$df, "\n")
        cat("Ratio:", result$ratio, "\n")
        if (result$overdispersed) {
          cat("Overdispersion detected; consider negative binomial or quasipoisson model.\n\n")
        } else {
          cat("No evidence of overdispersion.\n\n")
        }
      } else {
        print(result)
        cat("\n")
      }
    } else if (name == "zero_inflation") {
      if (is.list(result)) {
        cat("Observed zeros:", result$observed_zeros, "(", round(result$prop_observed * 100, 1), "%)\n")
        cat("Expected zeros:", round(result$expected_zeros, 1), "(", round(result$prop_expected * 100, 1), "%)\n")
        if (result$zero_inflated) {
          cat("Zero-inflation detected; consider zero-inflated Poisson or hurdle models.\n\n")
        } else {
          cat("No evidence of zero-inflation.\n\n")
        }
      } else {
        print(result)
        cat("\n")
      }
    } else if (name == "residual_analysis") {
      if (is.list(result)) {
        cat("Mean residual:", result$mean_residual, "\n")
        cat("SD residual:", result$sd_residual, "\n")
        cat("Min residual:", result$min_residual, "\n")
        cat("Max residual:", result$max_residual, "\n\n")
      } else {
        print(result)
        cat("\n")
      }
    } else if (is.list(result)) {
      print(result)
      cat("\n")
    } else {
      print(result)
      cat("\n")
    }
  }

  invisible(object)
}
