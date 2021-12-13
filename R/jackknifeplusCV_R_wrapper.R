#'jackknifeplusCV_c_wrapper
#'
#'
#' @param Xtrain #' n training samples, whose format must be matrix n*p 
#' @param Ytrain #' a response matrix of dimension n * 1
#' @param Xtest #' a test sample as matrix, whose format must be consistent with Xtrain 1*p
#' @param a #' probability coverage is 1-2a 0<a<1 
#' @param K #' divide data into K folders to do cross validation
#' @return #' conformal confidence interval of jackknife+CV
#' @export
#'
#' @examples 
#' Xtrain=matrix(rnorm(200),40,5)
#' Ytrain=matrix(rnorm(40),40,1)
#' Xtest=matrix(rnorm(5),1,5)
#' result = jackknifeplusCV_c_wrapper(Xtrain, Ytrain, Xtest, 0.05, 4)


# jackknife CV+

jackknifeplusCV_c_wrapper <- function(Xtrain, Ytrain, Xtest, a, K) {
  n <- nrow(Xtrain) # number of total data

  m <- n %/% K # number of data in every folder

  result <- jackknifeplusCV_c(Xtrain, Ytrain, Xtest, K) # Use C code
  q1 <- result$q1
  q2 <- result$q2
  interval <- c(sort(q1)[floor(a * (K * m + 1))], sort(q2)[ceiling((1 - a) * (K * m + 1))]) # Calculate interval
  return(interval)
}
