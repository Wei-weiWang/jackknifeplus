#'jackknifeplus
#'
#' @param Xtrain #' n training samples
#' @param Ytrain #' a response vector of size n
#' @param Xtest #' a test sample
#' @param Ytest #' a scalar, test sample's response value  
#' @param a #' probability coverage is 1-a 
#' @param predfunction #' a function that containing desired algorithm which input are Xtrain, Ytrain, Xtest, and output is predicted value(a scalar) of Xtest. 
#'
#' @return #' conformal confidence interval of jackknife+
#' @export
#'
#' @examples



# An example of linear regression function
# predY_LR = function(Xtrain, Ytrain, Xtest){
#   return(Xtest%*%lm(Ytrain~Xtrain)$coefficients)
# }

# Calculate celing(1-a)*(n+1) quantlile of a n vector  
# quantile_n_a = function(A, a){
#   n = length(A)
#   return(sort(A)[ceiling((1-a)*(n+1))])##this is null because of ceiling
# }
#(-q_n_a(-q1),q_n_a(q2))

jackknifeplus <- function(Xtrain, Ytrain, Xtest, Ytest, predfunction, a){
  n = nrow(Xtrain)
  for (i in 1:n) {
    predY = predfunction(Xtrain[-i,],Ytrain[-i],Xtrain[i,])#trainfunction and output leave one out residual
    Results_RLOO[i] = abs(Ytrain[i] - predY)
    q1[i] = predfunction(Xtrain[-i,],Ytrain[-i],Xtest) - Results_RLOO[i]# jackknife+ vector
    q2[i] = predfunction(Xtrain[-i,],Ytrain[-i],Xtest) + Results_RLOO[i]
    return(q1)
  }
}
