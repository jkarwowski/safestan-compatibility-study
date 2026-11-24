// Model 1: Time independent model for a simple pendulum.
// Created as part of a Bayesian Contnuous Inverse Kinmeatics paper.

data {
    int<lower=1> N;                     // Number of data poitns: nM*nS*nT
    int<lower=1> nM;                    // Number of markers
    int<lower=1> nD;                    // Number of dimensions
    int<lower=1> nT;                    // Number of timepoints
    int<lower=1> nK;                    // Number of Basis functions
    int<lower =1, upper = nK> nK2;     // Number of frequencies
    array[nT] real<lower=0> ts;               // Observed times

    array[N] int<lower=1, upper=nM> midx;     // marker idx
    array[N] int<lower=1, upper=nT> tidx;     // time idx

    matrix[nT, nK+1] fBasis;
    matrix[nT, nK+1] dfBasis;

    array[nM] vector[nD] x;                   // Known positions of markers in LCS
    array[N] vector[nD] y;                    // Observations  
}   

parameters {
    // Basis parameters for theta
    real<lower = -pi(), upper = pi()> mu_theta;  // Average angle over time.
    vector[nK] beta_theta;
    // Basis parameters for lsigma
    vector[nK+1] beta_lsigma;
    real <lower=0> epsilon_lsigma;
    vector[nT] delta_lsigma;
}

transformed parameters {
    array[nT] vector[nD] r;                    // base point over time
    vector[nT] theta;
    vector[nT] dtheta;
    vector[nT] sigma;

    for(t in 1:nT){
        r[t] = rep_vector(0, nD);                  // Basepoint is stationary throughout time.
    }
    
    // Model for theta
    theta[1:nT] = (rep_vector(1, nT) * mu_theta) + (2*atan(fBasis[1:nT, 2:(nK+1)] * beta_theta));
    dtheta[1:nT] = (2*dfBasis[1:nT, 2:(nK+1)] * beta_theta)./(1+(((fBasis[1:nT, 2:(nK+1)] * beta_theta)).*(fBasis[1:nT, 2:(nK+1)] * beta_theta)));

    // Model for sigma
    sigma = exp((fBasis * beta_lsigma) + delta_lsigma[1:nT]*epsilon_lsigma); // NCP prior on lsigma    
}

model {
    array[N] vector[nD] alpha;                    // Expected marker position
    matrix[nD, nD] Gam;                     // Rotation Matrix
// -------------------- Priors ---------------------------------------
    
    // Measurement noise
    beta_lsigma ~ normal(rep_vector(0, nK+1), 1e6);   
    epsilon_lsigma ~ uniform(0, 1);
    delta_lsigma ~ normal(rep_vector(0,nT), 1);

    // Theta.
    mu_theta ~ uniform(-pi(), pi());
    beta_theta ~ normal(rep_vector(0,nK), 0.2); // Uninformative after atan transformation.
// -------------------- Kinematic Model ---------------------------------------
    // Marker Model
    for(i in 1:N){
        Gam[1,1] = cos(theta[tidx[i]]); Gam[1,2] = -sin(theta[tidx[i]]);
        Gam[2,1] = sin(theta[tidx[i]]); Gam[2,2] = cos(theta[tidx[i]]);
        alpha[i] = r[tidx[i]] + (Gam*x[midx[i]]);
        y[i] ~ normal(alpha[i], sigma[tidx[i]]);
    }

}
