functions{
  int which_min(array[] real y ){
    int ans = sort_indices_asc(y)[1];
    return(ans);
  }
  real approximate_ca0(real x, array[] real x_pred, array[] real y_pred){
    int K = size(x_pred);
    array[K] real deltas;
    real ans;
    int i;
    if(size(y_pred) != K) reject("x_pred and y_pred aren't of the same size");
    for(k in 1:K) deltas[k] = abs(x_pred[k] - x);
    i = which_min(deltas);
    if(i != 1){
      real x1 = x_pred[i];
      real x2 = x_pred[i + 1];
      real y1 = y_pred[i];
      real y2 = y_pred[i + 1];
      ans = y1 + (y2-y1) * (x-x1)/(x2-x1);
    }else{
      ans = y_pred[i];
    }
    return(ans);
  }
}
data{
  int<lower=0> N0;
  array[N0] int y0;
  real<lower=0> alpha0;
  real<lower=0> beta0;
  int<lower=0> N;
  array[N] int y;
  real<lower=0> eta;
  real<lower=0> nu;
  /* Approximation stuff*/
  int<lower=0> K;
  array[K] real pred_grid_x;
  array[K] real pred_grid_y;
}
parameters{
  real<lower=0> lambda;
  real<lower=0,upper=1> a_0;
}
model{
  /* Power prior */
  target += -approximate_ca0(a_0, pred_grid_x, pred_grid_y);
  target += a_0 * poisson_lpmf(y0 | lambda) ;
  target += gamma_lpdf(lambda | alpha0, beta0);
  target += beta_lpdf(a_0 | eta, nu);
  /* Likelihood */
  target += poisson_lpmf(y | lambda);
}
