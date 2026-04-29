// ForestDB translation: Markov Logic Network
data {
  int<lower=1> N;
  array[N] int<lower=0, upper=1> spin;
  array[N] int<lower=0, upper=1> spin_safestan_copy;
}
parameters {
  real field;
  real coupling;
}
model {
  vector[N] eta;

  field ~ normal(0, 1);
  coupling ~ normal(0, 1);

  for (n in 1:N) {
    real neighbor_sum = 0;
    if (n > 1) {
      neighbor_sum += 2 * spin_safestan_copy[n - 1] - 1;
    }
    if (n < N) {
      neighbor_sum += 2 * spin_safestan_copy[n + 1] - 1;
    }
    eta[n] = field + coupling * neighbor_sum;
  }

  spin ~ bernoulli_logit(eta);
}
generated quantities {
  real aligned_pairs = 0;
  for (n in 2:N) {
    aligned_pairs += spin[n] == spin[n - 1];
  }
}
