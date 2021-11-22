#'jackknifeplus
#'
#' @param Xtrain #' n training samples
#' @param Ytrain #' a response vector of size n
#' @param Xtest #' a test sample
#' @param Ytest #' test sample's response value  
#' @param a #' probability coverage 
#' @param predfunction #' a function that containing desired algorithm which input are Xtrain, Ytrain, Xtest, and output is predicted value of Xtest. 
#'
#' @return #' conformal confidence interval of jackknife+
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
