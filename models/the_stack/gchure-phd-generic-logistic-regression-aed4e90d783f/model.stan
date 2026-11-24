/**
* Losgistic Regression
* --------------------------------------------------------------------------
* This Stan model performs Bayesian parameter estimation for the coefficients
* of a single regressor logistic regression neglecting any statistical error.
*
* Author: Griffin Chure
* Creation Date: March 19, 2018
* License: MIT
* Contact: gchure@caltech.edu
**/

data {
    int<lower=1> J; // Total number of distinct trials
    int<lower=1> N; // Total number of sample measurements.
    array[N] int<lower=0, upper=J> trial; // Vector containing trial IDs.
    array[N] int<lower=0, upper=1> output; // Categorial input vector.
    vector[N] predictor;  // Computed effective channel number.
    }

parameters {
    array[J] real beta_0; // Intercept - log odds of survival with no channels.
    array[J] real beta_1; // Slope - increase in log odds from +1 increase in channels.
    }

model {
    beta_0 ~ normal(0, 100); // Weakly informative prior for intercept
    beta_1 ~ normal(0, 100); // Weakly informative prior for slope

    // Likelihood as a logit Bernoulli distribution.
    for (i in 1:N){
        output[i] ~ bernoulli_logit(beta_0[trial[i]] + beta_1[trial[i]] * predictor[i]);
    }
}