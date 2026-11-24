data {
  int <lower=2> K;                      // num topics
  int <lower=1> D;                      // num docs
  int <lower=2> J;                      // num of unique words (vocab size)
  int <lower=2> I;                      // num of unique image regions
  int <lower=1> M;                      // total # of occurring words
  int <lower=1> N;                      // total # of occurring image regions
  array[M] int<lower=1, upper=J> featw;      // word m ID
  array[N] int<lower=1, upper=I> featr;      // region n ID
  array[M] int<lower=1, upper=D> docw;       // doc ID for each word instance
  array[N] int<lower=1, upper=D> docr;       // doc ID for each region instance
  vector <lower=0>[K] alpha;            // topic prior
  vector <lower=0>[J] mu;               // word prior
  vector <lower=0>[I] sigma;            // image region prior
}

parameters {
  array[D] simplex[K] theta;   // topic dist for doc d
  array[K] simplex[J] phi;     // word dist for topic k
  array[K] simplex[I] beta;    // region dist for topic k
}

model {
  for (d in 1:D){
    theta[d] ~ dirichlet(alpha);    // prior
  }
  for (k in 1:K){
    phi[k] ~ dirichlet(mu);         // prior
    beta[k] ~ dirichlet(sigma);     // prior
  }
  for (n in 1:N){
    array[K] real img_gamma;
    for (k in 1:K){
      img_gamma[k] = log(theta[docr[n],k]) + log(beta[k, featr[n]]);
    }
    target += log_sum_exp(img_gamma);// log-likelihood
  }
  for (m in 1:M){
    array[K] real wrd_gamma;
    for (k in 1:K){
      wrd_gamma[k] = log(theta[docw[m], k]) + log(phi[k, featw[m]]);
    }
    target += log_sum_exp(wrd_gamma);   // log-likelihood
  }
}
