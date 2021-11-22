#'jackknifeplus
#'
#' @param Xtrain #' n x p training data, 1st column should be 1s to account for intercept
#' @param Ytrain #' a vector of size n of class labels, from 0 to K-1
#' @param Xtest #' number of FIXED iterations of the algorithm, default value is 50
#' @param Ytest #' learning rate, default value is 0.1 
#' @param a #' ridge parameter, default value is 0.1
#' @param predfunction #' (optional) initial starting values of beta for the algorithm, should be p x K matrix
#'
#' @return #'beta - p x K matrix of estimated beta values after numIter iterations; objective - (numIter + 1) length vector of objective values of the function that we are minimizing at each iteration (+ starting value)
#' @export
#'
#' @examples


# n = 100
# p = 10
# Xtrain = matrix(rnorm(n*p),n,p)
# Ytrain = rnorm(n)
# Xtest = rnorm(p)
# Ytest = rnorm(1)
# Result = lm(Ytrain~Xtrain)
# beta = Result$coefficients
# Results_beta = matrix(0,p,n)
# Results_RLOO = rep(0,n)
# q = rep(0,n)
# for (i in 1:n) {
#   Results_beta[,i] = lm(Ytrain[1:i-1]+Ytrain[i+1,n]~Xtrain[1:i-1,]+Xtrain[i+1:n,])$coefficients #+要改
#   Results_RLOO[i] = abs(Ytrain[i] - Xtrain[i,]%*%Results_beta[,i])
#   q1[i] = Xtest%*%Results_beta[,i] - Results_RLOO[i]
#   q2[i] = Xtest%*%Results_beta[,i] + Results_RLOO[i]
#   
# }

# predY_LR = function(Xtrain, Ytrain, Xtest){
#   return(Xtest%*%lm(Ytrain~Xtrain)$coefficients)
# }
# quantile_n_a = function(A, a){
#   n = length(A)
#   return(sort(A)[ceiling((1-a)*(n+1))])##this is null because of ceiling
# }
#(-q_n_a(-q1),q_n_a(q2))
jackknifeplus <- function(Xtrain, Ytrain, Xtest, Ytest, predfunction, a){
  n = nrow(Xtrain)
  for (i in 1:n) {
    predY = predfunction(Xtrain[-i,],Ytrain[-i],Xtrain[i,])#trainfunction
    Results_RLOO[i] = abs(Ytrain[i] - predY)
    q1[i] = predfunction(Xtrain[-i,],Ytrain[-i],Xtest) - Results_RLOO[i]
    q2[i] = predfunction(Xtrain[-i,],Ytrain[-i],Xtest) + Results_RLOO[i]
    print(q1)
    print(q2)
    return(q1)
  }
}
