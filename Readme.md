## jackknifeplus package

# Introduction

Jackknife+ is a conformal prediction method to construct prediction intervals without distributional or algorithmic assumptions. Here, we only assume the training/testing data to be i.i.d. and the algorithm to be invariant to permutation of the training set. In this package, we assume the algorithm as linear regression. Jackknife+ constructs the prediction interval based on the sample quantile of leave-one-out (LOO) residuals. It enjoys a theoretical coverage of 1-2α.

In this package, several conformal prediction algorithms, including Jackknife+, Jackknife, Jackknife-mm, and K-fold cross-validation are implemented. The conformal prediction algorithms take the training dataset as input and produces a function mapping the test data to its prediction interval. 


## Installation instructions

Use git clone : download this package from github to local.

## Functions

We have four main R functions: jackknifeplus_c_wrapper, jackknife_c_wrapper, jackknifeplusMM_c_wrapper and jackknifeplusCV_c_wrapper which are to calculate prediction intervals by four different methods respectively: Jackknife+, Jackknife, Jackknife-mm, and K-fold cross-validation . Actually, we use C code inside to make them faster because these algorithms need to calculate loops. 

### Jackknife+ interval

$$\widehat{C}_{n, \alpha}^{\text {jackknife+ }}\left(X_{n+1}\right)=\left[\widehat{q}_{n, \alpha}^{-}\left\{\widehat{\mu}_{-i}\left(X_{n+1}\right)-R_{i}^{\mathrm{LOO}}\right\}, \widehat{q}_{n, \alpha}^{+}\left\{\widehat{\mu}_{-i}\left(X_{n+1}\right)+R_{i}^{\mathrm{LOO}}\right\}\right]$$