#include "RcppArmadillo.h"
#include <functional>
using namespace Rcpp;



//[[Rcpp::export]]
double predY_LR_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest){
  arma::vec coef = arma::solve(Xtrain, Ytrain);
  return((Xtest*coef).eval()(0,0));
}



//[[Rcpp::export]]
Rcpp::List jackknifeplusMM_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest){
  
  //  n <- nrow(Xtrain)
  int n = Xtrain.n_rows;
  
  
  //  Results_RLOO = 1:n
  arma::vec Results_RLOO(n);  
  
  
  //  Results_LOOtest = 1:n
  arma::vec Results_LOOtest(n);
  
  
  //  q1 = 1:n 
  arma::vec q1(n);
  //  q2 = 1:n
  arma::vec q2(n);
  
  int i;
  for(i=0;i<n;i++){
    
    arma::mat X=Xtrain;
    
    X.shed_row(i);
    
    
    arma::mat Y = Ytrain;
    Y.shed_row(i);
    
    arma::mat Xtrain_row = Xtrain.row(i);
    double predY = predY_LR_c(X,Y, Xtrain_row);
    
    
    Results_RLOO[i] = std::fabs(Ytrain[i] - predY);
    
    Results_LOOtest[i] = predY_LR_c(X, Y, Xtest.row(0));
    
    
    
  }
  
  
  return Rcpp::List::create(Rcpp::Named("Results_LOOtest") = Results_LOOtest,
                            Rcpp::Named("Results_RLOO") = Results_RLOO);
  
}




