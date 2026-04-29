data {
  int<lower=0> T; // // time points (equally spaced)
  vector[T] y; // mean corrected return at time t
}
parameters {
  real mu; // mean log volatility
  real<lower=-1, upper=1> phi; // persistence of volatility
  real<lower=0> sigma; // white noise shock scale
  vector[T] h; // log volatility at time t
}
model {
  matrix[T, T] Sigma_h;
  vector[T] mu_h;

  phi ~ uniform(-1, 1);
  sigma ~ cauchy(0, 5);
  mu ~ cauchy(0, 10);

  mu_h = rep_vector(mu, T);
  for (i in 1 : T) {
    for (j in 1 : T) {
      Sigma_h[i, j] = square(sigma) * pow(phi, abs(i - j)) / (1 - square(phi));
    }
  }

  h ~ multi_normal(mu_h, Sigma_h);
  y ~ normal(rep_vector(0, T), exp(h / 2));
}
