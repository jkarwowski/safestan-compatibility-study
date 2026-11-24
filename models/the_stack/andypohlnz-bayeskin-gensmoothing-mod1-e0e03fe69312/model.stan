// -------------- Model 1 - Time independent BIK --------------------------
// mod1.stan defines the time independent BIK model in stan syntax
// Written as part of:
//      A Generalised smoothing appraoch reduces uncertainty in Bayesian Solutions
//      to to time continuous planar inverse kinematics problems.
// 
//      By Andy Pohl
//      Human Perforamnce Labortory 
//      Faculty of Kinesiology
//      University of Calgary
//      December 2021
// ----------------------------------------------------------------- ----------

data {
    int<lower=1> N;                     // Number of data poitns: nL*nM*nS*nT
    int<lower=1> nL;                    // Number of links
    int<lower=1> nM;                    // Number of markers
    int<lower=1> nD;                    // Number of dimensions
    int<lower=1> nT;                    // Number of timepoints

    array[nT] real<lower=0> ts;               // Observed times

    array[N] int<lower=1, upper = nL> lidx;   // link idx
    array[N] int<lower=1, upper=nM> midx;     // marker idx
    array[N] int<lower=1, upper=nT> tidx;     // time idx

    array[nL, nM] vector[nD] x;               // Known positions of markers in LCS
    array[N] vector[nD] y;                    // Observed marker positions
    array[nL] vector[nD] ls;                  // length of each link


}   

parameters {
    array[nT] vector[nD] r;                                // Hip joint position over time.
    array[nT] vector<lower=-pi(), upper=pi()>[nL] theta;   // Segment angles over time 
    vector[nT] lsigma;                               // Measurement noise on log scale
}
transformed parameters {
    vector<lower=0>[nT] sigma;                  // Measurement noise on standard scale
    sigma = exp(lsigma);    
}

model {
    array[N] vector[nD] alpha;                    // Expected marker position
    array[nL, nT] vector[nD] J;                   // Joint centers for each link 
    array[nL, nT] matrix[nD, nD] Gam;             // Rotation Matrix

// -------------------- Priors ---------------------------------------
    // Measurement noise
    lsigma ~ normal(rep_vector(0,nT), 10);              
    
    // prior for r
    r[1:nT, 1] ~ normal(rep_vector(0, nT), 1e6);
    r[1:nT, 2] ~ normal(rep_vector(0, nT), 1e6);

    // Thetas uninformative
    for(l in 1:nL){
        theta[1:nT, l] ~ uniform(rep_vector(-pi(),nT),  rep_vector(pi(), nT));

    }


// -------------------- Kinematic Model ---------------------------------------
    // Rotation matricies
    for(t in 1:nT){
        for(l in 1:nL){
            Gam[l, t] = to_matrix([cos(theta[t,l]), sin(theta[t,l]), 
            -sin(theta[t,l]), cos(theta[t,l])], nD, nD);
        }
    }

    // Joint centers
    for(t in 1:nT){
        J[1, t] = r[t];
        for(l in 2:nL){
            J[l, t] = J[l-1, t] + (Gam[l-1, t, 1:nD, 1:nD] * ls[l-1]);
        }
    }

    // Marker Model
    for(i in 1:N){
        alpha[i] = J[lidx[i], tidx[i]] + Gam[lidx[i], tidx[i]]*x[lidx[i], midx[i]];
        y[i] ~ normal(alpha[i], sigma[tidx[i]]);
    }

}