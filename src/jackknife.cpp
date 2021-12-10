#include "RcppArmadillo.h"
#include <functional>
using namespace Rcpp;



//[[Rcpp::export]]
double predY_LR_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest){
  arma::vec coef = arma::solve(Xtrain, Ytrain);
  return((Xtest*coef).eval()(0,0));
}



//[[Rcpp::export]]
Rcpp::List jackknife_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest){
  
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
  
  double Results_test = predY_LR_c(Xtrain, Ytrain, Xtest);
  
  int i;
  for(i=0;i<n;i++){
    
    arma::mat X=Xtrain;
    
    X.shed_row(i);
    
    
    arma::mat Y = Ytrain;
    Y.shed_row(i);
    
    arma::mat Xtrain_row = Xtrain.row(i);
    double predY = predY_LR_c(X,Y, Xtrain_row);
    
    
    Results_RLOO[i] = std::fabs(Ytrain[i] - predY);
    
    
    
    q1[i] = Results_test - Results_RLOO[i];
    q2[i] = Results_test + Results_RLOO[i];
    
  }
  
  
  return Rcpp::List::create(Rcpp::Named("q1") = q1,
                            Rcpp::Named("q2") = q2);
  
}





