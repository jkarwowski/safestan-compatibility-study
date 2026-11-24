// Model 1: Time independent model for a simple pendulum.
// Created as part of a Bayesian Contnuous Inverse Kinmeatics paper.
data {
    int<lower=1> N;                     // Number of data poitns: nM*nS*nT
    int<lower=1> nM;                    // Number of markers
    int<lower=1> nD;                    // Number of dimensions
    int<lower=1> nT;                    // Number of timepoints

    array[nT] real<lower=0> ts;               // Observed times

    array[N] int<lower=1, upper=nM> midx;     // marker idx
    array[N] int<lower=1, upper=nT> tidx;     // time idx

    array[nM] vector[nD] x;                   // Known positions of markers in LCS
    array[N] vector[nD] y;                    // Observations  
}   

parameters {
    // Basis parameters
    vector[nT] theta;                       // basis coefficients    

    // Global Constants
    vector[nT] lsigma;             // measurement noise (m)
}

transformed parameters {
    array[nT] vector[nD] r;                    // base point over time
    vector[nT] sigma;
    vector[nT] dtheta;
  
    // r(t) is fixed to (0, 0)
    for(t in 1:nT){
        r[t] = rep_vector(0, nD);                  // Basepoint is stationary throughout time.
    }
    sigma = exp(lsigma);

    // Compute dtheta via finite differencing...
    dtheta[1] = (theta[2] - theta[1])/(ts[2]-ts[1]); //forward difference
    for(t in 2:(nT-1)){
        dtheta[t] = (theta[t+1] - theta[t-1])/(ts[t+1] - ts[t-1]);
    }
    dtheta[nT] = (theta[nT] - theta[nT-1])/(ts[nT] - ts[nT-1]); //backward difference
}

model {
    array[N] vector[nD] alpha;                    // Expected marker position
    matrix[nD, nD] Gam;                     // Rotation Matrix

// -------------------- Priors ---------------------------------------
    // Measurement noise
    lsigma ~ normal(rep_vector(0,nT), 10);  

    // Theta.
    theta ~ uniform(rep_vector(-pi(), nT), rep_vector(pi(), nT));

// -------------------- Kinematic Model ---------------------------------------
    // Marker Model
    for(i in 1:N){
        Gam[1,1] = cos(theta[tidx[i]]); Gam[1,2] = -sin(theta[tidx[i]]);
        Gam[2,1] = sin(theta[tidx[i]]); Gam[2,2] = cos(theta[tidx[i]]);
        alpha[i] = r[tidx[i]] + (Gam*x[midx[i]]);
        y[i] ~ normal(alpha[i], sigma[tidx[i]]);
    }
}
