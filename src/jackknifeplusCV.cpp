#include "RcppArmadillo.h"
using namespace Rcpp;



//[[Rcpp::export]]
double predY_LR_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest){
  arma::vec coef = arma::solve(Xtrain, Ytrain);
  return((Xtest*coef).eval()(0,0));
}



//[[Rcpp::export]]
Rcpp::List jackknifeplusCV_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest, int K) {
  
  //n <- nrow(Xtrain) # number of total data
  int n = Xtrain.n_rows;
  
  
  //m = n%/%K # number of data in every folder
  int m = n/K;  
  
  //q1 = 1:K*m
  arma::vec q1(K*m);
  
  //q2 = 1:K*m
  arma::vec q2(K*m);
  
  //Rcv = 1:K*m
  arma::vec Rcv(K*m);
  
  
  int i;
  int j;
  
  for(i=0; i<K; i++){
    
    arma::mat X = Xtrain;
    
    arma::mat Y = Ytrain;
    
    X.shed_rows(i*m, (i+1)*m-1 );
    
    Y.shed_rows(i*m, (i+1)*m-1 );
    
    double testCV = predY_LR_c(X, Y, Xtest);
    
    for(j=0; j<m; j++){
      
      Rcv[i*m+j] = std::fabs( Ytrain[i*m+j] - predY_LR_c(X, Y, Xtrain.row(i*m+j) )    );
      
      q1[i*m+j] = testCV - Rcv[i*m+j];
      
      q2[i*m+j] = testCV + Rcv[i*m+j];
      
      
    }
  }
  
  return Rcpp::List::create(Rcpp::Named("q1") = q1,
                            Rcpp::Named("q2") = q2);
  
  
}



