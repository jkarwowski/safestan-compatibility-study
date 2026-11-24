data {
  int<lower=1> K;
  int<lower=1> D;
  int<lower=1> W;
  int P;
  matrix<lower=0>[D,W] count_matrix;
  array[D] vector[P] x;
}
parameters {
  array[K] simplex[W] phi;    
  vector<lower=0>[W] eta;
  vector<lower=0, upper=1>[K] v;
  array[D] vector<lower=0, upper=1>[K] pi_dash;
  real<lower=0> sigma;
  real<lower=0> gamma;
  real<lower=0> xi;
  array[K] vector[P] lambda;
} 
transformed parameters {
  array[D] vector[K] alpha;
  array[D] simplex[K] pi;
  vector[K] beta;
  beta[1]=v[1];
  for (k in 2:K){
    beta[k]=v[k]*prod(1-(v[1:(k-1)]));
  }
  for (d in 1:D){
    for (k in 1:K){
      alpha[d,k] = sum(x[d,1:P].*lambda[k,1:P]);
      alpha[d,k] = exp(alpha[d,k])/(1+exp(alpha[d,k]));
    }
    pi[d,1]=pi_dash[d,1]*alpha[d,1];
  } 
  for (d in 1:D){
    for (k in 2:(K-1)){
      pi[d,k]=pi_dash[d,k]*alpha[d,k]*prod(1-(pi_dash[d,1:(k-1)]).*alpha[d,1:(k-1)]);
    } 
    pi[d,K]=1-sum(pi[d,1:(K-1)]);
  }
}
model {
  for (k in 1:K){
    for (p in 1:P){
      lambda[k,p] ~ normal(0, sigma);
    }
  }
  for (k in 1:K){
    v[k]~beta(1,gamma);
  }
  for (k in 1:K){
    for (d in 1:D){
      pi_dash[d,k]~beta(xi*beta[k],xi*(1-sum(beta[1:k])));
    }
  }
  for (k in 1:K)
    phi[k] ~ dirichlet(eta);
  for (d in 1:D) {
    for (w in 1:W) {
      array[K] real L;
      for (k in 1:K)
        L[k] = count_matrix[d,w]*(log(pi[d,k]) + log(phi[k,w]) );
      target+=log_sum_exp(L);
    }
  }
}