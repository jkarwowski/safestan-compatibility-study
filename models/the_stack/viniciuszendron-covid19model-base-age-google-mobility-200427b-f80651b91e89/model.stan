data {
  int<lower=1> M; // number of countries
  int<lower=1> N0; // number of initial days for which to estimate infections
  array[M] int<lower=1> N; // days of observed data for country m. each entry must be <= N2
  int<lower=1> N2; // days of observed data + # of days to forecast
  int<lower=1> A; // number of age bands
  int<lower=1> SI_CUT; // number of days in serial interval to consider
  int<lower=1> P_RES; // number of predictors for residential contacts
  int<lower=1> P_NONRES; // number of predictors for non-residential contacts
  array[M] int WKEND_IDX_N; // number of weekend indices in each location
  //	data
  array[M] real pop;
  matrix<lower=0, upper=1>[A,M] popByAge; // proportion of age bracket in population in location
  array[M] int epidemicStart;
  array[N2, M] int deaths; // reported deaths -- the rows with i > N contain -1 and should be ignored
  array[N2, M] int<lower=0> wkend_idx; //indices of 1:N2 that correspond to weekends in location m
  array[M] matrix[N2, P_RES] covariates_res; // predictors for residential contacts
  array[M] matrix[N2, P_NONRES] covariates_nonres; // predictors for non-residential contacts
  //	priors
  array[M] matrix[A, A] cntct_weekdays_mean; // mean of prior contact rates between age groups on weekdays
  array[M] matrix[A, A] cntct_weekends_mean; // mean of prior contact rates between age groups on weekends
  array[M] real<lower=0> ifr_country_scale; // relative probability of death for location, s days after infection, for age band a
  matrix<lower=0>[N2,A] ifr_age; // probability of death for age band a, stored N2 times
  row_vector[N2] rev_ifr_daysSinceInfection; // probability of death s days after infection in reverse order
  row_vector[SI_CUT] rev_serial_interval; // fixed pre-calculated serial interval using empirical data from Neil in reverse order
  int<lower=1, upper=A> init_A; // age band in which initial cases occur in the first N0 days
}

transformed data{
  vector<lower=0>[M] avg_cntct;
  vector[A] ones_vector_A;
  row_vector[A] ones_row_vector_A;
  ones_vector_A= rep_vector(1.,A);
  ones_row_vector_A= rep_row_vector(1.,A);
  
  for( m in 1:M )
  {
    avg_cntct[m] = popByAge[:,m]' * ( cntct_weekdays_mean[m] * ones_vector_A ) * 5./7.;
    avg_cntct[m] += popByAge[:,m]' * ( cntct_weekends_mean[m] * ones_vector_A ) * 2./7.;
  }
}

parameters {
  vector<lower=0>[M] R0; // R0
  //real<lower=0> kappa; // variance parameter for country-specific R0  
  real<lower=0> tau; // prior rate of expected number of cases per day in the first N0 days, for each country
  array[M] real<lower=0> e_cases_N0; // expected number of cases per day in the first N0 days, for each country  
  array[M] vector[P_RES] beta_res_wkend_state; // regression coefficients for time varying multipliers on residential contacts on weekends
  array[M] vector[P_RES] beta_res_wkday_state; // regression coefficients for time varying multipliers on residential contacts on weekdays  
  array[M] vector[P_NONRES] beta_nonres_wkday_state; // regression coefficients for time varying multipliers on non-residential contacts on weekdays
  real<lower=0> phi; // overdispersion parameter for likelihood model
  array[M] real<lower=0> ifr_noise;
  real<lower=0> kappa;
}

transformed parameters {
  // dummy variables
  // real<lower=0> saturation_adj;
    
  // probability of infection given contact in location m
  vector<lower=0>[M] rho0;
  
  // expected deaths by calendar day (1st dim) age (2nd dim) and country (3rd dim), under self-renewal model
  // and expected deaths by calendar day (rows) and country (cols), under self-renewal model
  array[M] matrix<lower=0>[N2, A] E_deathsByAge;
  matrix<lower=0>[N2,M] E_deaths= rep_matrix(0., N2, M);
  
  // expected new cases by calendar day, age, and location under self-renewal model
  // and a container to store the precomputed cases by age
  array[M] matrix<lower=0>[N2, A] E_casesByAge;
  row_vector<lower=0>[A] tmp_row_vector_A;
  
  // scaling of contacts after intervention effect on day t in location m
  matrix<lower=0>[N2, M] impact_intv_nonres;
  matrix<lower=0>[N2, M] impact_intv_res;

  // define probability of infection given contact in location m
  rho0 = R0 ./  avg_cntct;
  
  // define multipliers for residential contacts in each location for both weekdays and weekends
  // define multipliers for non-residential contacts in each location for both weekdays and weekends
  // multiply the multipliers with rho0 in each location
  // TODO use https://mc-stan.org/docs/2_18/stan-users-guide/QR-reparameterization-section.html
  for (m in 1:M)
  {
    impact_intv_res[:,m] = exp( covariates_res[m] * beta_res_wkday_state[m] );
    impact_intv_nonres[:,m] = exp( covariates_nonres[m] * beta_nonres_wkday_state[m] );
    impact_intv_res[ wkend_idx[1:WKEND_IDX_N[m],m], m] = exp( covariates_res[m][ wkend_idx[1:WKEND_IDX_N[m],m], :] * beta_res_wkend_state[m] );
    impact_intv_nonres[ wkend_idx[1:WKEND_IDX_N[m],m] ,m] = rep_vector(0., WKEND_IDX_N[m]);
    impact_intv_res[:,m] *= rho0[m];
    impact_intv_nonres[:,m] *= rho0[m];
  }
    
  // init expected cases by age and location
  // init expected cases by age and location in first N0 days
  for (m in 1:M)
  {
    E_casesByAge[m] = rep_matrix( 0., N2, A );
    E_casesByAge[m][1:N0,init_A] = rep_vector( e_cases_N0[m], N0 );
  }
  
  // calculate expected cases by age and country under self-renewal model after first N0 days
  // and adjusted for saturation
    for (m in 1:M)
  {
    for (t in (N0+1):N2)
    {
      tmp_row_vector_A = rev_serial_interval[max(1,(SI_CUT-t+2)):SI_CUT] * E_casesByAge[m][max(1,(t-SI_CUT)):(t-1),:];
      E_casesByAge[m][t,:] = tmp_row_vector_A * ( impact_intv_res[t,m] * cntct_weekends_mean[m] + impact_intv_nonres[t,m] * cntct_weekdays_mean[m] );
    }
  }
  
  // calculate expected deaths by age and country  
  for (m in 1:M)
  {
    E_deathsByAge[m] = rep_matrix( 0., N2, A );
    E_deathsByAge[m][1,:] = 1e-15 * E_casesByAge[m][1,:];
    for (t in 2:N2)
    {
      E_deathsByAge[m][t,:] = rev_ifr_daysSinceInfection[(N2-(t-1)+1):N2 ] * E_casesByAge[m][1:(t-1),:];
    }
    E_deathsByAge[m] .*= ifr_age;
    E_deathsByAge[m] *= (ifr_country_scale[m] * ifr_noise[m]);
  }
  
  // calculate expected deaths by country
  for (m in 1:M)
  {
    E_deaths[:,m] = E_deathsByAge[m] * ones_vector_A;
  }
}

model {
  // priors
  tau ~ exponential(0.03);
  e_cases_N0 ~ exponential(1/tau);
  phi ~ normal(0,5);
  for(m in 1:M)
  {
    beta_res_wkend_state[m] ~ normal(0,2);
    beta_res_wkday_state[m] ~ normal(0,2);
    beta_nonres_wkday_state[m] ~ normal(0,2);    
  }
  ifr_noise ~ normal(1,0.1);
  kappa ~ normal(0,0.5);
  R0 ~ normal(3.28, kappa); // citation: https://academic.oup.com/jtm/article/27/2/taaa021/5735319
  
  // likelihood
  for(m in 1:M){
    deaths[epidemicStart[m]:N[m], m] ~ neg_binomial_2(E_deaths[epidemicStart[m]:N[m], m], phi);
  }
}

generated quantities {
  matrix<lower=0>[N2,M] Rt; // Rt for each location
  array[M] matrix<lower=0>[N2, A] RtByAge; // Rt for each age band and each location
  matrix<lower=0>[N2,A] tmp;
  for( m in 1:M )
  {
    RtByAge[m] = rep_matrix( ones_row_vector_A*cntct_weekends_mean[m] , N2);
    RtByAge[m] .*= rep_matrix( impact_intv_res[:,m], A);
    tmp = rep_matrix( ones_row_vector_A*cntct_weekdays_mean[m] , N2);
    tmp .*= rep_matrix( impact_intv_nonres[:,m], A);
    RtByAge[m] += tmp;
    Rt[:,m] = RtByAge[m] * popByAge[:,m];
  }
}
