data{
    int N; // number of observations
    vector[N] y; // target margin
    array[N] int team_i; // team i vector
    array[N] int team_j; // team j vector
    array[N] int h_i; // home team i
    array[N] int h_j; // home team j
    int N_g; // number of teams (groups)
    array[N] int games_i; // number of games played i (time step)
    array[N] int games_j; // number of games played j (time step)
    int N_t; // max number of games played 
    real initial_prior; // initial theta values
    array[N] real fatigue_i; // rest for team i
    array[N] real fatigue_j; // rest for team j
}
parameters{
  real a; // correlation parameter
  real<lower=0> tau; // random variation
  matrix[N_g, N_t] theta;
  real<lower=0> sigma; // standard deviation of total model
  real<lower=0> w; // random noise from state space
  real home; // intercept for home indicator
  real fatigue;
}
model{
  //## state space model
    theta[,1] ~ normal(initial_prior, tau);
    for(t in 2:N_t) {
      for (g in 1:N_g){
        theta[g,t] ~ normal(a*theta[g,t-1],w);
  }
}
   for (i in 1:N){
     y[i] ~ normal(theta[team_i[i],games_i[i]] + h_i[i] * home + fatigue_i[i]*fatigue  - theta[team_j[i],games_j[i]] - h_j[i] * home - fatigue_j[i]*fatigue, sigma);
   }
}
