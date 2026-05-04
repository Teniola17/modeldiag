#' Plot Model Diagnostics
#'
#' Generates diagnostic plots for the fitted model.
#'
#' @param x An object of class "model_diagnostics".
#' @param ... Additional arguments passed to plotting functions.
#' @return None (plots are displayed).
#' @method plot model_diagnostics
#' @export
plot.model_diagnostics <- function(x, ...) {
  model <- x$model
  # We need to pass the model or store it.

  # Perhaps modify the structure to include the model.

  # For now, assume the user has the model.

  # But to make it work, perhaps plot.model_diagnostics takes model as argument.

  # Wait, better: since diagnose_model returns the object, and plot(x) where x is diagnostics, but we need the model.

  # So, perhaps store the model in the diagnostics object.

  # Yes, let's modify the diagnose_model functions to include model = model

  # Then, in plot, use x$model

  # Yes.

  if (x$model_type == "lm") {
    if (inherits(model, "glm")) {
      par(mfrow = c(2, 2))
      plot(model, which = 1:4)
    } else {
      par(mfrow = c(2, 3))
      plot(model, which = 1:4)
      acf(residuals(model), main = "ACF of Residuals")
    }
  } else if (x$model_type == "glm") {
    par(mfrow = c(2, 2))
    plot(model, which = 1:4)
  } else if (x$model_type == "coxph") {
    if (inherits(x$tests$proportional_hazards, "cox.zph")) {
      plot(x$tests$proportional_hazards, main = "Schoenfeld Residuals")
    }

    if (is.list(x$tests$influential_observations) && !is.null(x$tests$influential_observations$dfbetas)) {
      dfb <- x$tests$influential_observations$dfbetas
      for (i in seq_len(ncol(dfb))) {
        plot(dfb[, i], type = "h", main = paste("dfbeta for", colnames(dfb)[i]), xlab = "Observation", ylab = "dfbeta")
        abline(h = 0, lty = 2)
      }
    }

    mart <- residuals(model, type = "martingale")
    data_used <- model.frame(model)
    predictors <- names(coef(model))
    for (pred in predictors) {
      if (is.numeric(data_used[[pred]])) {
        plot(data_used[[pred]], mart, xlab = pred, ylab = "Martingale Residuals", main = paste("Martingale vs", pred))
        lines(lowess(data_used[[pred]], mart), col = "red")
      }
    }
  } else {
    message("Plotting not implemented for this model type.")
  }
}