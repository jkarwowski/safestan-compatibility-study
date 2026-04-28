data {
  int<lower=1> N;
  array[N + 1] real t;

  real x0;

  real mu;
  real<lower=0> gamma;
  real<lower=0> tau;
}

generated quantities {
  array[N + 1] real x;
  x[1] = x0;
  for (n in 1:N) {
    real decay = exp(-gamma * (t[n + 1] - t[n]));
    x[n + 1] = normal_rng(mu + (x[n] - mu) * decay, 0.7071 * tau * sqrt( (1 - decay) / gamma ) );
  }
}
