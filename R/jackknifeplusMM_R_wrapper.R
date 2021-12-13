#'jackknifeplusMM_c_wrapper
#'
#' @param Xtrain #' n training samples, whose format must be matrix n*p 
#' @param Ytrain #' a response matrix of dimension n * 1
#' @param Xtest #' a test sample as matrix, whose format must be consistent with Xtrain 1*p
#' @param a #' probability coverage is 1-2a 0<a<1 
#'
#' @return #' conformal confidence interval of jackknife+MM
#' @export
#'
#' @examples 
#' Xtrain=matrix(rnorm(200),40,5)
#' Ytrain=matrix(rnorm(40),40,1)
#' Xtest=matrix(rnorm(5),1,5)
#' result = jackknifeplusMM_c_wrapper(Xtrain, Ytrain, Xtest, 0.05)
#' 

#jackknife-minmax

jackknifeplusMM_c_wrapper <- function(Xtrain, Ytrain, Xtest, a) {
  n <- nrow(Xtrain)
  result <- jackknifeplusMM_c(Xtrain, Ytrain, Xtest) # Use C code
  # Calculate interval
  left <- min(result$Results_LOOtest - sort(result$Results_RLOO)[ceiling((1 - a) * (n + 1))])
  right <- max(result$Results_LOOtest + sort(result$Results_RLOO)[ceiling((1 - a) * (n + 1))])
  interval <- c(left, right)
  return(interval)
}
