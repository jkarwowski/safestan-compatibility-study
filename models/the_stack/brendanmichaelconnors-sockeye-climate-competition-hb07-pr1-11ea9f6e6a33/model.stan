// Hierarchical Ricker model + AR1 error term + 2 covariates + interaction
//
// Parameters:
//   alpha: exchangeable -> Normal(mu_alpha, sigma_alpha)
//      - non-centered parameterization
//      - sigma_alpha shared among series within a group
//   beta:  series-specific
//   gamma: exchangeable within a group -> Normal(mu_gamma, sigma_gamma)
//      - non-centered parameterization
//      - sigma_gamma shared among series within a group
//   kappa: exchangeable within a group -> Normal(mu_kappa, sigma_kappa)
//      - non-centered parameterization
//      - sigma_kappa shared among series within a group
//   chi: exchangeable within a group -> Normal(mu_chi, sigma_chi)
//      - non-centered parameterization
//      - sigma_chi shared among series within a group
//   sigma: series-specific
//   phi:   shared

data {
    int<lower=0> N;                       // total number of years
    int<lower=0> n_series;                // number of time series
    int<lower=0> Na_groups;               // number of alpha groups
    int<lower=0> Ng_groups;               // number of gamma groups
    array[n_series] int<lower=0> a_group;       // alpha grouping factor
    array[n_series] int<lower=0> g_group;       // gamma grouping factor
    array[n_series] int<lower=0> y_start;       // ragged start points for series
    array[n_series] int<lower=0> y_end;         // ragged end points for series
    array[N] real x1;                           // 1st covariate
    array[N] real x2;                           // 2nd covariate
    array[N] real x3;                           // 3rd covariate
    array[N] real y;                            // response
    int priors_only;                      // should likelihood be ignored?
}
parameters {
    array[Na_groups] real mu_alpha;             // population-level intercept
    array[Ng_groups] real mu_gamma;             // population-level x2 mean
    array[Ng_groups] real mu_kappa;             // population-level x3 mean
    array[Ng_groups] real mu_chi;               // population-level interaction mean
    array[n_series] real d_alpha;               // random alpha deviate
    array[n_series] real d_gamma;               // random gamma deviate
    array[n_series] real d_kappa;               // random kappa deviate
    array[n_series] real d_chi;                 // random chi deviate
    array[n_series] real beta;                  // slopes for 1st covariate
    array[n_series] real<lower=0> sigmaNC;      // residual SD (not corrected for AR1)
    array[Na_groups] real<lower=0> sigma_alpha; // population-level intercept SD
    real<lower=-1, upper=1> phi;          // autocorrelation parameter
    array[Ng_groups] real<lower=0> sigma_gamma; // population-level x2 SD
    array[Ng_groups] real<lower=0> sigma_kappa; // population-level x3 SD
    array[Ng_groups] real<lower=0> sigma_chi;   // population-level interaction SD
}
transformed parameters {
    array[n_series] real alpha;                 // series-specific intercept
    array[n_series] real gamma;                 // series-specific x2 effect
    array[n_series] real kappa;                 // series-specific x3 effect
    array[n_series] real chi;                   // series-specific interaction effect
    array[N] real yhat;                         // predicted values
    array[N] real epsilon;                      // residuals
    array[n_series] real<lower=0> sigma;        // residual SD (corrected for AR1)
    real tmp_epsilon;                     // temporary var to avoid deep copy

    for(i in 1:n_series) {
        alpha[i] = mu_alpha[a_group[i]] + sigma_alpha[a_group[i]] * d_alpha[i];
        gamma[i] = mu_gamma[g_group[i]] + sigma_gamma[g_group[i]] * d_gamma[i];
        kappa[i] = mu_kappa[g_group[i]] + sigma_kappa[g_group[i]] * d_gamma[i];
        chi[i]   = mu_chi[g_group[i]] + sigma_chi[g_group[i]] * d_chi[i];

        // first data point in series
        yhat[y_start[i]] = alpha[i] + beta[i] * x1[y_start[i]] + gamma[i] * x2[y_start[i]] + kappa[i] * x3[y_start[i]] + chi[i] * (x2[y_start[i]] * x3[y_start[i]]);
        epsilon[y_start[i]] = y[y_start[i]] - yhat[y_start[i]];

        for(t in (y_start[i]+1):y_end[i]) {
            tmp_epsilon = epsilon[t-1];
            yhat[t] = alpha[i] + beta[i] * x1[t] + gamma[i] * x2[t] + kappa[i] * x3[t] + chi[i] * (x2[t] * x3[t]) + phi * tmp_epsilon;
            epsilon[t] = y[t] - (yhat[t] - (phi * tmp_epsilon));
        }

        // AR1 impacts variance: sigma^2 = sigmaNC^2 * (1 - phi^2)
        sigma[i] = sqrt(sigmaNC[i] * sigmaNC[i] * (1 - phi * phi));
    }
}
model {
    // priors: population-level
    mu_alpha ~ normal(0, 5);
    sigma_alpha ~ cauchy(0, 2.5);
    phi ~ normal(0, 1);

    // priors: group-specific
    mu_gamma ~ normal(0, 5);
    sigma_gamma ~ cauchy(0, 2.5);
    mu_kappa ~ normal(0, 5);
    sigma_kappa ~ cauchy(0, 2.5);
    mu_chi ~ normal(0, 5);
    sigma_chi ~ cauchy(0, 2.5);

    // priors: series-specific
    d_alpha ~ normal(0, 1);
    d_gamma ~ normal(0, 1);
    d_kappa ~ normal(0, 1);
    d_chi ~ normal(0, 1);
    beta ~ normal(0, 5);
    sigmaNC ~ cauchy(0, 2.5);

    // likelihood
    if(!priors_only) {
        for(i in 1:n_series) {
            y[y_start[i]:y_end[i]] ~ normal(yhat[y_start[i]:y_end[i]], sigma[i]);
        }
    }
}
generated quantities {
    array[N] real log_lik;                      // log-likelihood
    array[N] real yrep;                         // replicated datasets
    array[N] real yresid;                       // realized residuals
    for(i in 1:n_series) {
        for(t in y_start[i]:y_end[i]) {
            log_lik[t] = normal_lpdf(y[t] | yhat[t], sigma[i]);
            yrep[t] = normal_rng(yhat[t], sigma[i]);
            yresid[t] = y[t] - yhat[t];
        }
    }
}

