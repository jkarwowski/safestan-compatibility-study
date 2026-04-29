// ForestDB translation: 1D Ising
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
  vector[N] spin_logit;
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
    spin_logit[n] = field + coupling * neighbor_sum;
  }
  spin ~ bernoulli_logit(spin_logit);
}
generated quantities {
  real aligned_pairs = 0;
  for (n in 2:N) {
    aligned_pairs += spin[n] == spin[n - 1];
  }
}
