## jackknifeplus package

# Introduction

Jackknife+ is a conformal prediction method to construct prediction intervals without distributional or algorithmic assumptions. Here, we only assume the training/testing data to be i.i.d. and the algorithm to be invariant to permutation of the training set. In this package, we assume the algorithm as linear regression. Jackknife+ constructs the prediction interval based on the sample quantile of leave-one-out (LOO) residuals. It enjoys a theoretical coverage of 1-2α.

In this package, several conformal prediction algorithms, including Jackknife+, Jackknife, Jackknife-mm, and K-fold cross-validation are implemented. The conformal prediction algorithms take the training dataset as input and produces a function mapping the test data to its prediction interval. 


## Installation instructions

Use git clone : download this package from github to local.

## Future work
Create C++ code using R Armadillo to make the algorithm faster.
Add Jackknife-mm and K-fold cross-validation algorithms. 
Create more examples to implement these algorithms.
