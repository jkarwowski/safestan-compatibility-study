data {
  // Defining dimensions
  int<lower=1> N_teams; // Number of teams in model
  array[N_teams] int<lower=1> N_obs; // number of observations
  int<lower=1> T_int; // number of time intervals
  array[N_teams] int<lower=1> L1_r; // Level 1 row space of TPT
  array[N_teams] int<lower=1> L1_c; // Level 1 column space of TPT
  int<lower=2> L2_r; // Level 2 row space of TPT
  int<lower=2> L2_c; // Level 2 column space of TPT
  int<lower=2> L3_r; // Level 3 row space of TPT
  int<lower=2> L3_c; // Level 3 column space of TPT
  // Raw data
  array[max(N_obs), N_teams] int<lower=0> S_next; // indexing next state (given a_n = 'no shot')
  array[max(N_obs), N_teams] int<lower=0> S_orig; // indexing current state
  array[max(N_obs), N_teams] int<lower=0, upper=T_int> S_time; // indexing time interval of each moment
  // Indexes to connect hierarchies
  array[L1_c[1]] int<lower=1> L1_to_L2_team_1;
  array[L1_c[2]] int<lower=1> L1_to_L2_team_2;
  array[L2_c] int<lower=1> L2_to_L3;
  // Final-stage (Hyperprior) fixed values
   row_vector[T_int] omega_mean; // this is the prior gamma values
   real half_cauchy_scale; //  hyperprior scale value of SDs
}

parameters {
  array[L1_r[1]] matrix[L1_c[1], T_int] lambda_team_1;
  array[L1_r[2]] matrix[L1_c[2], T_int] lambda_team_2;
  array[L2_r] matrix[L2_c, T_int] zeta;
  array[L3_r] matrix[L3_c, T_int] omega;
  real<lower=0> sigma_lambda;
  real<lower=0> sigma_zeta;
  real<lower=0> sigma_omega;
  real<lower=0,upper = 1> rho;
}

transformed parameters {
  // Construct AR(1) matrices
  matrix[T_int, T_int] Sigma_lambda;
  matrix[T_int, T_int] Sigma_zeta;
  matrix[T_int, T_int] Sigma_omega;
  for(i in 1:T_int){
    for(j in 1:T_int){
      Sigma_lambda[i,j] = pow(sigma_lambda, 2)*pow(rho, abs(i-j)); 
      Sigma_zeta[i,j] = pow(sigma_zeta,2)*pow(rho, abs(i-j)); 
      Sigma_omega[i,j] = pow(sigma_omega,2)*pow(rho, abs(i-j)); 
    }
  }
}

model {
   // Likelihood
  for(t in 1:N_teams){
    if(t == 1){
      for(n in 1:N_obs[t]){
        S_next[n,t] ~ categorical_logit(col(lambda_team_1[S_orig[n,t]], S_time[n,t]));
      }
    } else {
        for(n in 1:N_obs[t]){
          S_next[n,t] ~ categorical_logit(col(lambda_team_1[S_orig[n,t]], S_time[n,t]));
        } 
    }
  }

  // First stage of hierarchy  
  for(i in 1:L1_r[1]){
    for(j in 1:L1_c[1]){
      lambda_team_1[i][j, ] ~ multi_normal(zeta[L1_to_L2_team_1[i]][L1_to_L2_team_1[j]], Sigma_lambda);
    }
  }
  for(i in 1:L1_r[2]){
    for(j in 1:L1_c[2]){
      lambda_team_2[i][j, ] ~ multi_normal(zeta[L1_to_L2_team_2[i]][L1_to_L2_team_2[j]], Sigma_lambda);
    }
  }
  // Second stage of hierarchy
  for(i in 1:L2_r){
    for(j in 1:L2_c){
      zeta[i][j, ] ~ multi_normal(omega[L2_to_L3[i]][L2_to_L3[j]], Sigma_zeta);
    }
  }
  // Final-stage hyperpriors
  for(i in 1:L3_r){
    for(j in 1:L3_c){
      omega[i][j, ] ~ multi_normal(omega_mean, Sigma_omega);
    }
  }
  // AR(1) Hyperpriors
  sigma_lambda ~ cauchy(0, half_cauchy_scale);
  sigma_zeta ~ cauchy(0, half_cauchy_scale);
  sigma_omega ~ cauchy(0, half_cauchy_scale);
  rho ~ uniform(0, 1);
}

// generated quantities {
//   matrix[K_m,L_m] phat[N];
//   matrix[K_g,L_g] phatG[N];
//   for(n in 1:N){
//     for(k in 1:K_m){
//       phat[n][k] = to_row_vector(softmax(theta[k][,n]));
//     }
//     for(k in 1:K_g){
//       phatG[n][k] = to_row_vector(softmax(thetaG[k][,n]));
//     }
//   }
// }
