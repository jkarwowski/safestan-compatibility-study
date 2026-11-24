data {
  int<lower=0> N; // number of observations
	int<lower=0> J; // number of grid cells
	vector [N] xvar1;  //locations for observations
	vector [J-1] duxvar1;  //distances between unique locations
  array[N] int<lower=0> xrank1; //rank order of location for each obs
	array[N] int<lower=0> y;  // response for obs j
}

transformed data {
	real muy;
	real sdy;
	array[N] real logy;
  array[N] real ry;
  for (j in 1:N) {
    logy[j] = log(y[j]+0.5);
    ry[j] = 1.0*y[j];
    }
  muy = log(mean(ry));
	sdy = sd(logy);
}

parameters {
	array[J-1] real delta;
	real theta0;
}

transformed parameters{
	vector[J] theta;
	theta[1] = 5*sdy*theta0 + muy;
	for (j in 1:(J-1)){
	 	theta[j+1] = delta[j]*sqrt(duxvar1[j]) + theta[j];
	 	}
}

model {
	theta0 ~ normal(0, 1);
	delta ~ double_exponential(0, 1);
	for (i in 1:N){
	  y[i] ~ poisson_log(theta[xrank1[i]]);
	  }
}

generated quantities {
  vector[N] log_lik;
  for (i in 1:N) {
    log_lik[i] = poisson_log_lpmf(y[i] | theta[xrank1[i]]);
  }
}
