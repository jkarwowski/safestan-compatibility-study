data {
  int<lower=1> N;                   // # of individuals
  int<lower=1> K;                   // # of predictors
  int<lower=2> J;                   // number of available alternatives
  array[N] int<lower=1, upper=J> y;       // outcome of chosen alternative
  matrix[N*J, K] x;                 // predictor matrix
  array[N] vector<lower=0,upper=1>[J] Z;  // # index if alternative was considered 
}
parameters {
  vector[K] beta;
}
model {
  array[N] vector[J] utilities;
  //beta ~ normal(0, 5);
  beta ~ cauchy(0, 2.5); 
  
  for (n in 1:N) {
    utilities[n] = x[((n-1)*J+1):(n*J),] * beta;
    //utilities[n] = utilities[n] - (100 * Z[n]);
    utilities[n] = utilities[n] .* Z[n];
    y[n] ~ categorical(softmax(utilities[n]));
  }
}
