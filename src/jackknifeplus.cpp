#include "RcppArmadillo.h"
//[[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;



//[[Rcpp::export]]
double predY_LR_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest){
  arma::vec coef = arma::solve(Xtrain, Ytrain);
  return((Xtest*coef).eval()(0,0));
}

//[[Rcpp::export]]
Rcpp::List jackknifeplus_c(const arma::mat& Xtrain, const arma::mat& Ytrain, const arma::mat& Xtest){
  
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

    
    q1[i] = Results_LOOtest[i] - Results_RLOO[i];
    q2[i] = Results_LOOtest[i] + Results_RLOO[i];
   
  }
  

  return Rcpp::List::create(Rcpp::Named("q1") = q1,
                            Rcpp::Named("q2") = q2);

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
