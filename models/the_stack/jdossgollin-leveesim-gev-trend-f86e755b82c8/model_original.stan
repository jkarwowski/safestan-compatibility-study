/* 
Fit a GEV distribution with a linear trend in the location parameter
and a constant coefficient of variation
Partially based on http://bechtel.colorado.edu/~bracken/tutorials/stan/
*/
functions{
  real gev_lpdf(real y, real mu, real sigma, real xi) {
    // Implements the GEV
    // mu and sigma should be vectors that have been calculated from
    // the trend parameterization
    real z;
    real inv_xi;
    real neg_inv_xi; 
    real inv_xi_p1; 
    real lp;

    z = 1 + (y - mu) * xi / sigma;
    inv_xi = 1 / xi;
    neg_inv_xi = -inv_xi; 
    inv_xi_p1 = 1 + inv_xi; 

    lp = inv_xi_p1 * log(z) + pow(z, neg_inv_xi);
    
    return -lp - log(sigma);
  }
}
data {
  int<lower=0> N;           // how many data points
  vector[N] y;              // the variable to fit 
  vector[N] time;           // the time observations
  real time_offset;         // what counts as the "zero" time
  real loc_base_expected;   // prior mean on loc_base
  real loc_base_std;        // prior stdev on loc_base
  real loc_trend_expected;  // prior mean on loc_trend
  real loc_trend_std;       // prior std on loc_trend
  real coeff_var_expected;  // prior mean on coeff_var
  real coeff_var_std;       // prior std on coeff_var
  real sigma_min;           // the minimum allowable value of the scale
}
transformed data {
  vector[N] time_adj;       // center the time on `time_offset`
  for (n in 1:N){
    time_adj[n] = time[n] - time_offset;
  }
}
parameters {
  real<lower=-0.5,upper=0.5> shape; // there is no trend on the shape parameter
  real loc_base;
  real loc_trend;
  real<lower=0> coeff_var;
}
transformed parameters{
  real loc[N];
  real<lower=0> scale[N];
  for (n in 1:N){
    loc[n] = loc_base + loc_trend * time_adj[n];
    scale[n] = coeff_var * loc[n];
    if (scale[n] < sigma_min){
      scale[n] = sigma_min;
    }
  }
}
model {
  // informative prior on shape parameter -- should be near 0
  real shape_plus_half;
  shape_plus_half = shape + 0.5;
  shape_plus_half ~ beta(5, 5);
  // priors on parameters
  loc_base ~ normal(loc_base_expected, loc_base_std);
  loc_trend ~ normal(loc_trend_expected, loc_trend_std);
  coeff_var ~ normal(coeff_var_expected, coeff_var_std);
  // Data Model
  for (n in 1:N){
    y[n] ~ gev(loc[n], scale[n], shape);
  }
}