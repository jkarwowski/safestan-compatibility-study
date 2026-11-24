/**
 * Dawid-Skene model with long-form data input and fixed priors.
 * The true labels are marginalized out in the model block and then
 * reconstituted in the generated quantities block on the log scale.
 * The Stan User's Guide's chapter on Latent Discrete Models has an
 * explanation of the marginalization for full-panel data.
 *
 * Parameters and genrated quantities in output:
 *
 * pi[k]: prevalence of category k
 *
 * theta[j, k, k']: probability that annotator j provides label k' if
 * the true category is k
 *
 * log_p_cat[i, k]:  log probability that true category of item i is k
 */
data {
  int<lower = 0> N;

  int<lower = 0> I;
  array[N] int<lower = 1, upper = I> item;
  
  int<lower = 0> J;
  array[N] int<lower = 1, upper = J> rater;

  int<lower = 0> K;
  array[N] int<lower = 1, upper = K> label;
}
transformed data {
  array[K] vector<lower = 0>[K] alpha;
  for (k in 1:K) {
    alpha[k] = rep_vector(2, K);
    alpha[k, k] = 2 * K;
  }
}
parameters {
  simplex[K] pi; 
  array[J, K] simplex[K] theta;
}
model {
  vector[K] log_pi = log(pi);
  array[J, K] vector[K] log_theta = log(theta);

  // likelihood
  array[I] vector[K] lp;
  for (i in 1:I)
    lp[i] = log_pi;
  for (n in 1:N)
    for (k in 1:K)
      lp[item[n], k] += log_theta[rater[n], k, label[n]];
  for (i in 1:I)
    target += log_sum_exp(lp[i]);

  // prior
  for (j in 1:J)
    for (k in 1:K)
      theta[j, k] ~ dirichlet(alpha[k]);
}
generated quantities {
  array[I] vector[K] log_p_cat;
  {
    vector[K] log_pi = log(pi);
    array[J, K] vector[K] log_theta = log(theta);
    array[I] vector[K] lp;
    for (i in 1:I)
      lp[i] = log_pi;
    for (n in 1:N)
      for (k in 1:K)
        lp[item[n], k] += log_theta[rater[n], k, label[n]];
    for (i in 1:I)
      log_p_cat[i] = lp[i] - log_sum_exp(lp[i]);
  }
}
