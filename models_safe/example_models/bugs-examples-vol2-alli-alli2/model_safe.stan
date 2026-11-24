// Alligators: multinomial - logistic regression 
//  http://www.openbugs.net/Examples/Aligators.html

//# specify the model using Poisson distribution 

data {
  int I; // 4 
  int J; // 2 
  int K; // 5 
  array[I, J, K] int X;
  array[I * J * K] int X_safestan_flat;
}
parameters {
  vector[K - 1] alpha0;
  vector[(I - 1) * (K - 1)] beta0_raw;
  vector[(J - 1) * (K - 1)] gamma0_raw;
  vector[I * J] lambda_raw;
}
transformed parameters {
  vector[K] alpha;
  matrix[I - 1, K - 1] beta0;
  matrix[J - 1, K - 1] gamma0;
  matrix[I, J] lambda;
  array[I] vector[K] beta;
  array[J] vector[K] gamma;
  
  alpha[1] = 0;
  for (k in 1 : (K - 1)) {
    alpha[k + 1] = alpha0[k];
  }
  for (i in 1 : (I - 1)) {
    for (k in 1 : (K - 1)) {
      beta0[i, k] = beta0_raw[(i - 1) * (K - 1) + k];
    }
  }
  for (j in 1 : (J - 1)) {
    for (k in 1 : (K - 1)) {
      gamma0[j, k] = gamma0_raw[(j - 1) * (K - 1) + k];
    }
  }
  for (i in 1 : I) {
    for (j in 1 : J) {
      lambda[i, j] = lambda_raw[(i - 1) * J + j];
    }
  }
  
  for (i in 1 : I) {
    beta[i, 1] = 0;
  }
  for (k in 1 : K) {
    beta[1, k] = 0;
  }
  
  for (i in 1 : (I - 1)) {
    for (k in 1 : (K - 1)) {
      beta[i + 1, k + 1] = beta0[i, k];
    }
  }
  
  for (j in 1 : J) {
    gamma[j, 1] = 0;
  }
  for (k in 1 : K) {
    gamma[1, k] = 0;
  }
  
  for (j in 1 : (J - 1)) {
    for (k in 1 : (K - 1)) {
      gamma[j + 1, k + 1] = gamma0[j, k];
    }
  }
}
model {
  array[I * J * K] real eta_safestan_flat;
  int pos;
  
  alpha0 ~ normal(0, 320);
  beta0_raw ~ normal(0, 320);
  gamma0_raw ~ normal(0, 320);
  lambda_raw ~ normal(0, 320);
  
  pos = 1;
  for (i in 1 : I) {
    for (j in 1 : J) {
      for (k in 1 : K) {
        eta_safestan_flat[pos] = lambda[i, j] + alpha[k] + beta[i, k]
                                  + gamma[j, k];
        pos = pos + 1;
      }
    }
  }
  X_safestan_flat ~ poisson_log(eta_safestan_flat);
}
generated quantities {
  matrix[I, K] b;
  matrix[J, K] g;
  
  for (k in 1 : K) {
    for (i in 1 : I) {
      b[i, k] = beta[i, k];
    }
    for (j in 1 : J) {
      g[j, k] = gamma[j, k];
    }
  }
  
  for (k in 1 : K) {
    real mean_beta_k;
    mean_beta_k = mean(col(b, k));
    for (i in 1 : I) {
      b[i, k] = beta[i, k] - mean_beta_k;
    }
  }
  
  for (k in 1 : K) {
    real mean_gamma_k;
    mean_gamma_k = mean(col(g, k));
    for (j in 1 : J) {
      g[j, k] = gamma[j, k] - mean_gamma_k;
    }
  }
}
