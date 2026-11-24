// Stan model mixture gaus model - training with random theta
      data {
      int N_subjects;
      int N_trials;
      array[N_subjects] int N_trials_valid;
      int N_stim;
      real Cue;
      real theta_b0;
      array[N_trials, N_subjects] real RT;
      array[N_trials, N_subjects] real Run;
      array[N_trials, N_subjects] real Contingency;
      array[N_trials, N_subjects] int Stim;
      }
      
      parameters {
      // Fixed effect: mu1(Anticipatory), mu2(Cue dependent), theta1(100% contingency), theta2(50% contingency), sigma_e1, sigma_e2
      real<lower=0, upper=Cue+100> mu1_fix; // Anticipatory mean
      real<lower=Cue> mu2_fix; // Cue dependent mean
      array[2] real theta_fix; // theta0 + slope (for run)
      array[2] real<lower=0> sigma_e; // error terms
      
      // SD for random effect: (mu1 - not used), theta1, theta2
      //real<lower=0> mu1_sd[1]; // SD of the random effects around the fixed mean 
      array[2] real<lower=0> theta_sub_sd; // SD of the random effects around the fixed thetas
      array[2] real<lower=0> theta_stim_sd; // SD of the random effects around the fixed thetas
      
      // Random effect parameter: mu1, theta1, theta2
      //real <upper=Cue+100> mu1_rand[N_subjects]; // random intercept for early onest Gaussian's mean
      array[N_subjects] real theta_1_sub; // random intercept for theta
      array[N_subjects] real theta_2_sub; // random intercept for theta
      array[N_subjects, N_stim] real theta_1_sub_stim; // random intercept for theta
      array[N_subjects, N_stim] real theta_2_sub_stim; // random intercept for theta
      }
      
      model {
      //priors
      mu1_fix ~ normal(500,500);
      mu2_fix ~ normal(1000,500);
      theta_fix ~ normal(0,0.7);
      sigma_e ~ normal(0,1000);
      theta_sub_sd ~ normal(0.7,0.7);
      theta_stim_sd ~ normal(0.7,0.7);
      //mu1_sd ~ normal(0,150);
      
      
      //likelihood
      for (s in 1:N_subjects){
      // mu1_rand[s] ~ normal(mu1_fix,mu1_sd);
      theta_1_sub[s] ~ normal(theta_fix[1],theta_sub_sd[1]); // 100% contingency
      theta_2_sub[s] ~ normal(theta_fix[2],theta_sub_sd[2]); // 50% contingency
      
      for (t in 1:N_trials_valid[s]){
      int stim_i;
      stim_i = Stim[t,s]; 
      theta_1_sub_stim[s,stim_i] ~ normal(theta_1_sub[s],theta_stim_sd[1]); // 100% contingency
      theta_2_sub_stim[s,stim_i] ~ normal(theta_2_sub[s],theta_stim_sd[2]); // 50% contingency
      
      target += log_mix(Phi_approx(theta_b0 + (Contingency[t,s]*theta_1_sub_stim[s,stim_i] + (1-Contingency[t,s])*theta_2_sub_stim[s,stim_i]) * Run[t,s]),
      //normal_lpdf(RT[t,s] | mu1_rand[s] , sigma_e[1]),
      normal_lpdf(RT[t,s] | mu1_fix , sigma_e[1]),
      normal_lpdf(RT[t,s] | mu2_fix, sigma_e[2]));
      }
      }
      }
