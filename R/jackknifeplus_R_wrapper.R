#'jackknifeplus_c_wrapper
#'
#' @param Xtrain #' n training samples, whose format must be consistent with input of predfunction user provides 
#' @param Ytrain #' a response vector of size n
#' @param Xtest #' a test sample, whose format must be consistent with input of predfunction user provides
#' @param a #' probability coverage is 1-2a 
#'
#' @return #' conformal confidence interval of jackknife+
#' @export
#'
#' @examples #' jackknifeplus_c_wrapper(Xtrain, Ytrain, Xtest, 0.05)
#' 
 

jackknifeplus_c_wrapper <- function(Xtrain, Ytrain, Xtest, a) {
n <- nrow(Xtrain)
result = jackknifeplus_c(Xtrain,Ytrain ,Xtest)
q1 = result$q1
q2 = result$q2
interval <- c(sort(q1)[floor(a*(n+1))], sort(q2)[ceiling((1-a)*(n+1))])
return(interval)
}

