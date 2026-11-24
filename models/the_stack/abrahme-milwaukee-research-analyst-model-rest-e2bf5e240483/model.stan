data{
    int N; // number of observations
    vector[N] y; // target margin
    array[N] int team_i; // team i vector
    array[N] int team_j; // team j vector
    array[N] int h_i; // home team i
    array[N] int h_j; // home team j
    int N_g; // number of players (groups)
    array[N] real rest_i; // covariate rest i
    array[N] real rest_j; // covariate rest j
}
parameters{
    array[N_g] vector[2] beta_p; // vector for slope and intercept
    vector<lower=0>[2] sigma_p; // sd for intercept and slope
    vector[2] beta; // intercept and slope hyper priors
    corr_matrix[2] Omega; // correlation matrix
    vector<lower=0>[N_g] omega;
    real<lower=0> sigma;
    real<lower=0> tau_omega;
}

model{
    // vector for conditional mean storage
    vector[N] mu;

    // priors
    Omega ~ lkj_corr(2);
    sigma_p ~ exponential(1);
    beta ~ normal(0,1);
    tau_omega ~ cauchy(0,.25)T[0,];
    sigma ~ cauchy(0,1)T[0,];
    beta_p ~ multi_normal(beta, quad_form_diag(Omega,sigma_p));
    omega ~ lognormal(0,tau_omega);

    // define mu for the Gaussian
    for( t in 1:N ) {
      mu[t] = (beta_p[team_i[t],1] + beta_p[team_i[t],2]*h_i[t] -omega[team_i[t]]*rest_i[t]) -
              (beta_p[team_j[t],1] + beta_p[team_j[t],2]*h_j[t] -omega[team_j[t]]*rest_j[t]);
    }

// the likelihood
    y ~ normal(mu,sigma);

}
