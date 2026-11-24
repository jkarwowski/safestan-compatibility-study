// Sea Level Model
// See paper for details
data {
    int<lower=0>  N;        // length of historical record
    int<lower=0> M;         // how many future years to simulate
    real year_offset;       // build the polynomial around what year
    real sea_level[N];      // historical sea level, in cm
    real years[N];          // year corresponding to historical observations
    real future_years[M];   // future years for which to simulate SLR
    real a_mean;            // prior mean on a
    real a_std;             // prior standard deviation on b
    real b_mean;
    real b_std;
    real c_mean;
    real c_std;
    real bstar_mean;
    real bstar_std;
    real sigma_mean;
    real sigma_std;
    real slr_2100_mu1;      // prior mean on SLR in 2100 for gaussian 1
    real slr_2100_sigma1;   // prior stdev on SLR in 2100 for gaussian 1
    real slr_2100_mu2;      // prior mean on SLR in 2100 for gaussian 2
    real slr_2100_sigma2;   // prior stdev on SLR in 2100 for gaussian 2
    real w_1;               // mixture probability for gaussian 1
}
parameters {
    real a;
    real b;
    real c;
    real<lower=0> bstar;
    real<lower=2020, upper=2100> tstar;
    real<lower=0> sigma;
}
transformed parameters {
    real y_pred[M];
    real y_past[N];
    for (m in 1:M){
        y_pred[m] = a + b * (future_years[m] - year_offset) + c * square(future_years[m] - year_offset);
        if (future_years[m] > tstar){
            y_pred[m] += bstar * (future_years[m] - tstar);
        }
    }
    for (n in 1:N){
        y_past[n] = a + b * (years[n] - year_offset) + c * square(years[n] - year_offset);
    }
}
model {
    for (n in 1:N){
        sea_level[n] ~ normal(y_past[n], sigma);
    }
    sigma ~ normal(sigma_mean, sigma_std);
    a ~ normal(a_mean, a_std);
    b ~ normal(b_mean, b_std);
    c ~ normal(c_mean, c_std);
    bstar ~ normal(bstar_mean, bstar_std);
    // prior on SLR in 2100 follows a normal mixture distribution
    target += log_mix(
        w_1,
        normal_lpdf(y_pred[M] | slr_2100_mu1, slr_2100_sigma1),
        normal_lpdf(y_pred[M] | slr_2100_mu2, slr_2100_sigma2)
    );
}