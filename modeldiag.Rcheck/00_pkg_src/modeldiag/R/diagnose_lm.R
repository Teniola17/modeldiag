#' @method diagnose_model glm
#' @rdname diagnose_model
#' @export
diagnose_model.glm <- function(model, ...) {
  if (model$family$family == "binomial") {
    tests <- list(
      multicollinearity = check_vif(model),
      linearity_logit = check_box_tidwell(model),
      goodness_of_fit = check_hosmer_lemeshow(model),
      influential_observations = check_influential_glm(model),
      separation_issues = check_separation(model)
    )
  } else if (model$family$family == "poisson") {
    tests <- list(
      multicollinearity = check_vif(model),
      overdispersion = check_overdispersion(model),
      zero_inflation = check_zero_inflation(model),
      influential_observations = check_influential_glm(model),
      residual_analysis = check_residual_analysis(model)
    )
  } else {
    stop("diagnose_model.glm only supports binomial and poisson families.")
  }

  structure(
    list(
      model_type = "glm",
      model = model,
      tests = tests
    ),
    class = "model_diagnostics"
  )
}

#' @method diagnose_model lm
#' @rdname diagnose_model
#' @export
diagnose_model.lm <- function(model, ...) {
  if (inherits(model, "glm")) {
    return(diagnose_model.glm(model, ...))
  }

  tests <- list(
    multicollinearity = check_vif(model),
    heteroskedasticity = check_heteroskedasticity(model),
    autocorrelation = check_autocorrelation(model),
    normality = check_normality(model),
    outliers = check_outliers(model)
  )

  structure(
    list(
      model_type = "lm",
      model = model,
      tests = tests
    ),
    class = "model_diagnostics"
  )
}

#' @method diagnose_model coxph
#' @rdname diagnose_model
#' @export
diagnose_model.coxph <- function(model, ...) {
  tests <- list(
    multicollinearity = check_vif(model),
    proportional_hazards = check_proportional_hazards(model),
    influential_observations = check_influential_coxph(model),
    functional_form = check_functional_form_coxph(model)
  )

  structure(
    list(
      model_type = "coxph",
      model = model,
      tests = tests
    ),
    class = "model_diagnostics"
  )
}
