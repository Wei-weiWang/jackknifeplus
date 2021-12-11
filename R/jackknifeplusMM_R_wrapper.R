#'jackknifeplusMM_c_wrapper
#'
#' @param Xtrain #' n training samples, whose format must be consistent with input of predfunction user provides 
#' @param Ytrain #' a response vector of size n
#' @param Xtest #' a test sample, whose format must be consistent with input of predfunction user provides
#' @param a #' probability coverage is 1-2a 
#' @return #' conformal confidence interval of jackknife+
#' @export
#'
#' @examples #' jackknifeplusMM_c_wrapper(Xtrain, Ytrain, Xtest, 0.05)

#jackknife-minmax

jackknifeplusMM_c_wrapper <- function(Xtrain, Ytrain, Xtest, a) {
  n <- nrow(Xtrain)
  result = jackknifeplusMM_c(Xtrain,Ytrain ,Xtest)
  left = min(result$Results_LOOtest -  sort(result$Results_RLOO)[ceiling((1-a)*(n+1))] )
  right = max(result$Results_LOOtest +  sort(result$Results_RLOO)[ceiling((1-a)*(n+1))] )
  interval <- c(left, right)
  return(interval)
}
