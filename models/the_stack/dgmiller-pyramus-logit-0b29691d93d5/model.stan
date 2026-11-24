// conditional logit for DCEs
data {
  int<lower=2> A; // number of alternatives (choices) per question
  int<lower=1> L; // number of feature variables
  int<lower=1> N; // number of observations
  int<lower=1> Ntest; // number of out of sample observations

  array[N] matrix[A, L] X; // matrix of attributes for each obs
  array[N] int<lower=1, upper=A> Y; // observed responses

  array[Ntest] matrix[A, L] Xhat;

  real mu; // mean for Beta
  real<lower=0> sigma; // variance of Beta

}

parameters {
  vector[L] Beta; // matrix of beta coefficients
}

model {
  Beta ~ normal(mu, sigma); // prior for Beta
  for (n in 1:N) {
    Y[n] ~ categorical_logit(X[n]*Beta);
  }
}

generated quantities {
  // Yhat is predicted choices for new data.
  array[Ntest] int<lower=0, upper=A> Yhat;

  for (n in 1:Ntest) {
    Yhat[n] = categorical_logit_rng(Xhat[n]*Beta);
  }
}
