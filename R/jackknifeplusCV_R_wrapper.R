#'jackknifeplus
#'
#' @param Xtrain #' n training samples, whose format must be consistent with input of predfunction user provides 
#' @param Ytrain #' a response vector of size n
#' @param Xtest #' a test sample, whose format must be consistent with input of predfunction user provides
#' @param Ytest #' a scalar, test sample's response value  
#' @param a #' probability coverage is 1-2a 
#' @param predfunction #' a function that containing desired algorithm which input are Xtrain, Ytrain, Xtest, and output is predicted value, a scalar, of Xtest. 
#'
#' @return #' conformal confidence interval of jackknife+
#' @export
#'
#' @examples #' jackknifeplusCV_c_wrapper(Xtrain, Ytrain, Xtest, 0.05, 4)


# jackknife CV+

jackknifeplusCV_c_wrapper <- function(Xtrain, Ytrain, Xtest, a, K) {
  
  n <- nrow(Xtrain) # number of total data
  
  m = n%/%K # number of data in every folder
  
  result = jackknifeplusCV_c(Xtrain,Ytrain ,Xtest , K)
  q1 = result$q1
  q2 = result$q2
  interval <- c(sort(q1)[floor(a*(K*m+1))], sort(q2)[ceiling((1-a)*(K*m+1))])
  return(interval)
}
