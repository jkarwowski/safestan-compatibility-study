parameters {
  real a;          // Unknown truncation
  real<lower=a> x; // Constrained parameter
}

model {
  a ~ normal(0, 1);          // Truncation density
  x ~ normal(0, 1) T[a, ];   // Nominal target density with corrected normalization
}
