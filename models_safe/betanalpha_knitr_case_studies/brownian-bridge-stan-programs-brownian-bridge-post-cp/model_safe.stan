data {
  int<lower=1> N;
  array[N] real ts;

  real x_left;
  real x_right;

  array[N - 2] int left_idxs;
  array[N - 2] int center_idxs;
  array[N - 2] int right_idxs;

  int<lower=1> N_obs;
  array[N_obs] int obs_idxs;
  array[N_obs] real x_obs;
  real<lower=0> sigma;
}

transformed data {
  vector[N - 2] bridge_mean;
  matrix[N - 2, N - 2] bridge_precision;

  {
    matrix[N - 2, N - 2] A;
    vector[N - 2] b;
    vector[N - 2] inv_var;
    matrix[N - 2, N - 2] weighted_A;

    A = rep_matrix(0, N - 2, N - 2);
    b = rep_vector(0, N - 2);

    for (n in 1:(N - 2)) {
      int c = center_idxs[n];
      int l = left_idxs[n];
      int r = right_idxs[n];
      real alpha = (ts[r] - ts[c]) / (ts[r] - ts[l]);
      real beta = (ts[c] - ts[l]) / (ts[r] - ts[l]);
      real sigma2 = (ts[r] - ts[c]) * (ts[c] - ts[l]) / (ts[r] - ts[l]);

      A[n, c - 1] = 1;

      if (l == 1) {
        b[n] += alpha * x_left;
      } else if (l == N) {
        b[n] += alpha * x_right;
      } else {
        A[n, l - 1] -= alpha;
      }

      if (r == 1) {
        b[n] += beta * x_left;
      } else if (r == N) {
        b[n] += beta * x_right;
      } else {
        A[n, r - 1] -= beta;
      }

      inv_var[n] = 1 / sigma2;
    }

    bridge_mean = mdivide_left(A, b);
    weighted_A = diag_pre_multiply(sqrt(inv_var), A);
    bridge_precision = transpose(weighted_A) * weighted_A;
  }
}

parameters {
  vector[N - 2] interior_xs;
}

transformed parameters {
  vector[N] xs;
  xs[1] = x_left;
  xs[2:(N - 1)] = interior_xs;
  xs[N] = x_right;
}

model {
  interior_xs ~ multi_normal_prec(bridge_mean, bridge_precision);
  x_obs ~ normal(xs[obs_idxs], sigma);
}
