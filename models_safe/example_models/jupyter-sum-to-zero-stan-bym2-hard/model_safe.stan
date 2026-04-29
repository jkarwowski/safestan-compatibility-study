data {
  int<lower=0> N;
  array[N] int<lower=0> y; // count outcomes
  vector<lower=0>[N] E; // exposure
  int<lower=1> K; // num covariates
  matrix[N, K] xs; // design matrix

  // spatial structure
  int<lower = 0> N_edges;  // number of neighbor pairs
  array[2, N_edges] int<lower = 1, upper = N> neighbors;  // columnwise adjacent

  real tau; // scaling factor
}
transformed data {
  vector[N] log_E = log(E);
  // center continuous predictors 
  vector[K] means_xs;  // column means of xs before centering
  matrix[N, K] xs_centered;  // centered version of xs
  matrix[N, N - 1] phi_basis = rep_matrix(0, N, N - 1);
  matrix[N_edges, N] neighbor_diffs = rep_matrix(0, N_edges, N);
  matrix[N_edges, N - 1] projected_neighbor_diffs;
  matrix[N - 1, N - 1] phi_precision;
  for (k in 1:K) {
    means_xs[k] = mean(xs[, k]);
    xs_centered[, k] = xs[, k] - means_xs[k];
  }
  if (N > 1) {
    for (n in 1:(N - 1)) {
      phi_basis[n, n] = 1;
      phi_basis[N, n] = -1;
    }
  }
  if (N_edges > 0) {
    for (e in 1:N_edges) {
      neighbor_diffs[e, neighbors[1, e]] += 1;
      neighbor_diffs[e, neighbors[2, e]] -= 1;
    }
  }
  projected_neighbor_diffs = neighbor_diffs * phi_basis;
  phi_precision = projected_neighbor_diffs' * projected_neighbor_diffs;
}
parameters {
  real beta0; // intercept
  vector[K] betas; // covariates
  real<lower=0, upper=1> rho; // proportion of spatial variance
  vector[N-1] phi_raw; // spatial random effects
  vector[N] theta; // heterogeneous random effects
  real<lower = 0> sigma;  // scale of combined effects
}
transformed parameters {
  vector[N] phi = append_row(phi_raw, -sum(phi_raw));
  vector[N] gamma = (sqrt(1 - rho) * theta + sqrt(rho / tau) * phi);  // BYM2
}
model {
  rho ~ beta(0.5, 0.5);
  phi_raw ~ multi_normal_prec(rep_vector(0, N - 1), phi_precision);
  beta0 ~ std_normal();
  betas ~ std_normal();
  theta ~ std_normal();
  sigma ~ std_normal();
  y ~ poisson_log(log_E + beta0 + xs_centered * betas + gamma * sigma);
}
generated quantities {
  real beta_intercept = beta0 - dot_product(means_xs, betas);  // adjust intercept
  array[N] int y_rep;
  {
    vector[N] eta = log_E + beta0 + xs_centered * betas + gamma * sigma;
    if (max(eta) > 26) {
      // avoid overflow in poisson_log_rng
      print("max eta too big: ", max(eta));
      for (n in 1:N) {
        y_rep[n] = -1;
        // log_lik[n] = -1;
      }
    } else {
      for (n in 1:N) {
        y_rep[n] = poisson_log_rng(eta[n]);
      }
    }
  }
}
