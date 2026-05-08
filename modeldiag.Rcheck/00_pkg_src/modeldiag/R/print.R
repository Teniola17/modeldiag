#' Print Model Diagnostics
#'
#' Prints a summary of the model diagnostics object.
#'
#' @param x An object of class "model_diagnostics".
#' @param ... Additional arguments passed to print.
#' @return The object x, invisibly.
#' @method print model_diagnostics
#' @export
print.model_diagnostics <- function(x, ...) {
  cat("Model Diagnostics\n")
  cat("------------------\n")
  cat("Model type:", x$model_type, "\n\n")

  cat("Available tests:\n")
  print(names(x$tests))

  invisible(x)
}