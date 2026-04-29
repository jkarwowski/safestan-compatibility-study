functions {
  int first_capture(array[] int y_i) {
    for (k in 1 : size(y_i)) {
      if (y_i[k]) {
        return k;
      }
    }
    return 0;
  }

  int last_capture(array[] int y_i) {
    for (k_rev in 0 : (size(y_i) - 1)) {
      int k = size(y_i) - k_rev;
      if (y_i[k]) {
        return k;
      }
    }
    return 0;
  }

  matrix prob_uncaptured(int nind, int n_occasions, matrix p, matrix phi) {
    matrix[nind, n_occasions] chi;

    for (i in 1 : nind) {
      chi[i, n_occasions] = 1.0;
      for (t in 1 : (n_occasions - 1)) {
        int t_curr = n_occasions - t;
        int t_next = t_curr + 1;
        chi[i, t_curr] = (1 - phi[i, t_curr])
                         + phi[i, t_curr] * (1 - p[i, t_next - 1])
                           * chi[i, t_next];
      }
    }
    return chi;
  }
}
data {
  int<lower=0> nind;
  int<lower=2> n_occasions;
  array[nind, n_occasions] int<lower=0, upper=1> y;
  int<lower=1> max_age;
  array[nind, n_occasions - 1] int<lower=0, upper=max_age> x;
  int<lower=0> n_bernoulli_safestan;
  array[n_bernoulli_safestan] int<lower=0, upper=1> y_bernoulli_safestan;
}
transformed data {
  int n_occ_minus_1 = n_occasions - 1;
  array[nind] int<lower=0, upper=n_occasions> first;
  array[nind] int<lower=0, upper=n_occasions> last;

  for (i in 1 : nind) {
    first[i] = first_capture(y[i]);
  }
  for (i in 1 : nind) {
    last[i] = last_capture(y[i]);
  }
}
parameters {
  real<lower=0, upper=1> mean_p;
  vector<lower=0, upper=1>[max_age] beta;
}
transformed parameters {
  matrix<lower=0, upper=1>[nind, n_occ_minus_1] phi;
  matrix<lower=0, upper=1>[nind, n_occ_minus_1] p;
  matrix<lower=0, upper=1>[nind, n_occasions] chi;
  vector<lower=0, upper=1>[n_bernoulli_safestan] theta_bernoulli_safestan;

  for (i in 1 : nind) {
    for (t in 1 : n_occ_minus_1) {
      phi[i, t] = 0;
      p[i, t] = 0;
    }
    if (first[i] > 0 && first[i] <= n_occ_minus_1) {
      for (t in first[i] : n_occ_minus_1) {
        phi[i, t] = beta[x[i, t]];
        p[i, t] = mean_p;
      }
    }
  }

  chi = prob_uncaptured(nind, n_occasions, p, phi);

  {
    int k = 1;
    if (n_bernoulli_safestan > 0) {
      for (k_init in 1 : n_bernoulli_safestan) {
        theta_bernoulli_safestan[k_init] = 0;
      }
    }
    for (i in 1 : nind) {
      if (first[i] > 0) {
        if (last[i] > first[i]) {
          for (t in (first[i] + 1) : last[i]) {
            theta_bernoulli_safestan[k] = phi[i, t - 1];
            k += 1;
            theta_bernoulli_safestan[k] = p[i, t - 1];
            k += 1;
          }
        }
        theta_bernoulli_safestan[k] = chi[i, last[i]];
        k += 1;
      }
    }
  }
}
model {
  mean_p ~ uniform(0, 1);
  beta ~ uniform(0, 1);
  y_bernoulli_safestan ~ bernoulli(theta_bernoulli_safestan);
}
