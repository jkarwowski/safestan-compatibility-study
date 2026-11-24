functions {

  /* 
   * returns impact_intv_res (first index) and impact_intv_nonres
   * (second index) for one country
   */
  array[] vector country_impact(
      real R0_local,
      vector beta_res_wkend,
      vector beta_res_wkday,
      vector beta_nonres_wkday,
      int N2,
      // wkend_idx[1:WKEND_IDX_N[m],m]
      array[] int wkend_idx_local,
      real avg_cntct_local,
      matrix covariates_res_local,
      matrix covariates_nonres_local
                          )
  {
    int num_wkend_idx_local = size(wkend_idx_local);
    
    // probability of infection given contact in location m
    real rho0 = R0_local / avg_cntct_local;
    real log_rho0 = log(rho0);
    
    real zero = 0.0;

    // scaling of contacts after intervention effect on day t in location m
    vector[N2] impact_intv_res;
    vector[N2] impact_intv_nonres;

    // define multipliers for residential contacts in each location for both weekdays and weekends
    // define multipliers for non-residential contacts in each location for both weekdays and weekends
    // multiply the multipliers with rho0 in each location
    // TODO use
    // https://mc-stan.org/docs/2_18/stan-users-guide/QR-reparameterization-section.html
    impact_intv_res = exp( log_rho0 + covariates_res_local * beta_res_wkday );
    impact_intv_nonres = exp( log_rho0 + covariates_nonres_local * beta_nonres_wkday );
    impact_intv_res[ wkend_idx_local ] = exp( log_rho0 + covariates_res_local[ wkend_idx_local ] * beta_res_wkend );
    impact_intv_nonres[ wkend_idx_local ] = rep_vector(zero, num_wkend_idx_local );

    return ({impact_intv_res, impact_intv_nonres});
  }
  
    matrix country_EcasesByAge(// parameters
                              real R0_local,
                              real e_cases_N0_local,
                              vector beta_res_wkend,
                              vector beta_res_wkday,
                              vector beta_nonres_wkday,
                              // data
                              int N0,
                              int N2,
                              int A,
                              int SI_CUT,
                              // wkend_idx[1:WKEND_IDX_N[m],m]
                              array[] int wkend_idx_local,
                              real avg_cntct_local,
                              matrix covariates_res_local,
                              matrix covariates_nonres_local,
                              matrix cntct_weekends_mean_local,
                              matrix cntct_weekdays_mean_local,
                              row_vector rev_serial_interval,
                              int init_A
                              )
  {
    // dummy variables
    // real<lower=0> saturation_adj;
    real zero = 0.0;
  
    // expected new cases by calendar day, age, and location under self-renewal model
    // and a container to store the precomputed cases by age
    matrix[N2,A] E_casesByAge = rep_matrix( zero, N2, A );

    array[2] vector[N2] impact_intv = country_impact(R0_local,
                                               beta_res_wkend, beta_res_wkday, beta_nonres_wkday,
                                               N2,
                                               wkend_idx_local,
                                               avg_cntct_local,
                                               covariates_res_local, covariates_nonres_local);
  
    // init expected cases by age and location in first N0 days
    E_casesByAge[1:N0,init_A] = rep_vector( e_cases_N0_local, N0 );
  
    // calculate expected cases by age and country under self-renewal model after first N0 days
    // and adjusted for saturation
    for (t in (N0+1):N2)
    {
      int start_idx_rev_serial = SI_CUT-t+2;
      int start_idx_E_casesByAge = t-SI_CUT;
      //tmp_row_vector_A = rev_serial_interval[max(1,(SI_CUT-t+2)):SI_CUT] * E_casesByAge[m][max(1,(t-SI_CUT)):(t-1),:];
      //E_casesByAge[m][t,:] = tmp_row_vector_A * (
      //impact_intv_res[t,m] * cntct_weekends_mean[m] +
      //impact_intv_nonres[t,m] * cntct_weekdays_mean[m] );
      if(start_idx_rev_serial < 1) {
        start_idx_rev_serial = 1;
      }
      if(start_idx_E_casesByAge < 1) {
        start_idx_E_casesByAge = 1;
      }
      {
        row_vector[A] tmp_row_vector_A = rev_serial_interval[start_idx_rev_serial:SI_CUT] * E_casesByAge[start_idx_E_casesByAge:(t-1)];
        //E_casesByAge[t] = tmp_row_vector_A * ( impact_intv_res[t] *
        //cntct_weekends_mean_local + impact_intv_nonres[t] *
        //cntct_weekdays_mean_local );
        // better version which does the reduction first (row-vector x
        //matrix) and then adds the scaled results
        //E_casesByAge[t] = impact_intv_res[t]    * (tmp_row_vector_A * cntct_weekends_mean_local) +
        //                  impact_intv_nonres[t] * (tmp_row_vector_A * cntct_weekdays_mean_local);
        E_casesByAge[t] = impact_intv[1,t] * (tmp_row_vector_A * cntct_weekends_mean_local) +
                          impact_intv[2,t] * (tmp_row_vector_A * cntct_weekdays_mean_local);
      }
    }
  
    return(E_casesByAge);
  }
  
  matrix country_EdeathsByAge(// parameters
                              real R0_local,
                              real e_cases_N0_local,
                              vector beta_res_wkend,
                              vector beta_res_wkday,
                              vector beta_nonres_wkday,
                              real phi,
                              real ifr_noise_local,
                              // data
                              int N0,
                              int N2,
                              int A,
                              int SI_CUT,
                              // wkend_idx[1:WKEND_IDX_N[m],m]
                              array[] int wkend_idx_local,
                              real avg_cntct_local,
                              matrix covariates_res_local,
                              matrix covariates_nonres_local,
                              matrix cntct_weekends_mean_local,
                              matrix cntct_weekdays_mean_local,
                              row_vector rev_ifr_daysSinceInfection,
                              real ifr_country_scale_local,
                              row_vector ifr_age,
                              row_vector rev_serial_interval,
                              int init_A
                              )
  {
    // dummy variables
    // real<lower=0> saturation_adj;

    real zero = 0.0;
    
    // expected deaths by calendar day (1st dim) age (2nd dim) and country (3rd dim), under self-renewal model
    // and expected deaths by calendar day (rows) and country (cols), under self-renewal model
    //matrix<lower=0>[N2,A] E_deathsByAge[M];
    matrix[N2,A] E_deathsByAge = rep_matrix( zero, N2, A );
  
    // expected new cases by calendar day, age, and location under self-renewal model
    // and a container to store the precomputed cases by age
    matrix[N2,A] E_casesByAge = country_EcasesByAge(R0_local, e_cases_N0_local, beta_res_wkend,
                              beta_res_wkday, beta_nonres_wkday, N0, N2, A, SI_CUT, wkend_idx_local,
                              avg_cntct_local, covariates_res_local, covariates_nonres_local,
                              cntct_weekends_mean_local, cntct_weekdays_mean_local, rev_serial_interval, init_A);
                              
    // calculate expected deaths by age and country  
    E_deathsByAge[1] = 1e-15 * E_casesByAge[1];
    for (t in 2:N2)
    {
      E_deathsByAge[t] = rev_ifr_daysSinceInfection[(N2-(t-1)+1):N2 ] * E_casesByAge[1:(t-1)];
    }
    E_deathsByAge .*= rep_matrix(ifr_age, N2);
    E_deathsByAge *= (ifr_country_scale_local * ifr_noise_local);
  
    return(E_deathsByAge);
  }

  real countries_log_dens(array[,] int deaths_slice,
                          int start,
                          int end,
                          // parameters
                          vector R0,
                          array[] real e_cases_N0,
                          vector beta_res_wkend,
                          vector beta_res_wkday,
                          vector beta_nonres_wkday,
                          real phi,
                          array[] real ifr_noise,
                          // data
                          int N0,
                          int N2,
                          int A,
                          int SI_CUT,
                          // wkend_idx[1:WKEND_IDX_N[m],m]
                          array[] int num_wkend_idx,
                          array[,] int wkend_idx,
                          vector avg_cntct,
                          array[] matrix covariates_res,
                          array[] matrix covariates_nonres,
                          array[] matrix cntct_weekends_mean,
                          array[] matrix cntct_weekdays_mean,
                          row_vector rev_ifr_daysSinceInfection,
                          array[] real ifr_country_scale,
                          row_vector ifr_age,
                          row_vector rev_serial_interval,
                          array[] int epidemicStart,
                          array[] int N,
                          int init_A,
                          array[] int A_AD,
                          array[] int dataByAgestart,
                          array[] matrix map_age,
                          array[,,] int deathsByAge,
                          array[,] int map_country,
                          data vector ones_vector_A
                          )
  {
    real lpmf = 0.0;
    int M_slice = end - start + 1;
    int index_country_slice; 
    int min_age_slice;
    int max_age_slice;
    vector[N2] E_deaths;
    
    for(m_slice in 1:M_slice) {
      int m = m_slice + start - 1;
      matrix[N2, A] E_deathsByAge =
          country_EdeathsByAge(
              R0[m],
              e_cases_N0[m],
              beta_res_wkend,
              beta_res_wkday,
              beta_nonres_wkday,
              phi,
              ifr_noise[m],
              N0,
              N2,
              A,
              SI_CUT,
              wkend_idx[1:num_wkend_idx[m],m],
              avg_cntct[m],
              covariates_res[m],
              covariates_nonres[m],
              cntct_weekends_mean[m],
              cntct_weekdays_mean[m],
              rev_ifr_daysSinceInfection,
              ifr_country_scale[m],
              ifr_age,
              rev_serial_interval,
              init_A
                               );

      E_deaths = E_deathsByAge * ones_vector_A;
      
      // likelihood
      if(map_country[m,1] == 1){
        index_country_slice = map_country[m,2];
        lpmf += neg_binomial_2_lpmf(deaths_slice[m_slice, epidemicStart[m]:(dataByAgestart[index_country_slice]-1)] | E_deaths[epidemicStart[m]:(dataByAgestart[index_country_slice]-1)], phi );
        
        for(a in 1:A_AD[index_country_slice]){
          // first day of data is sumulated death
          lpmf += neg_binomial_2_lpmf(deathsByAge[dataByAgestart[index_country_slice], a, index_country_slice] | 
                                          rep_row_vector(1.0, (dataByAgestart[index_country_slice]-epidemicStart[m]+1)) * E_deathsByAge[epidemicStart[m]:dataByAgestart[index_country_slice], :] * map_age[index_country_slice][:, a], phi );
          // after daily death
          lpmf += neg_binomial_2_lpmf(deathsByAge[(dataByAgestart[index_country_slice]+1):N[m], a, index_country_slice] | 
                                          E_deathsByAge[(dataByAgestart[index_country_slice]+1):N[m], :] * map_age[index_country_slice][:, a], phi );
          }
      }
      if(map_country[m,1] == 0){
        lpmf += neg_binomial_2_lpmf(deaths_slice[m_slice, epidemicStart[m]:N[m]]| E_deaths[epidemicStart[m]:N[m]], phi );
      }
   }
    return(lpmf);
  }
}

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
  // data by age
  int<lower=0> M_AD; // number of countries with deaths by age data
  array[M_AD] int<lower=1> dataByAgestart; // start of death by age data
  array[N2, A, M_AD] int deathsByAge; // reported deaths by age -- the rows with i < dataByAgestart[M_AD] contain -1 and should be ignored + the column with j > A2[M_AD] contain -1 and should be ignored 
  array[M_AD] int<lower=2> A_AD; // number of age groups reported 
  array[M_AD] matrix[A, A] map_age; // map the age groups reported with 5 y age group -- the column with j > A2[M_AD] contain -1 and should be ignored
  array[M, 2] int map_country; // first column indicates if country has death by age date (1 if yes), 2 column map the country to M_AD
  //	priors
  array[M] matrix[A, A] cntct_weekdays_mean; // mean of prior contact rates between age groups on weekdays
  array[M] matrix[A, A] cntct_weekends_mean; // mean of prior contact rates between age groups on weekends
  array[M] real<lower=0> ifr_country_scale; // relative probability of death for location, s days after infection, for age band a
  array[A, 2] real<lower=0> hyperpara_ifr_age; // Beta hyper-parameters for probability of death in age band a
  row_vector[N2] rev_ifr_daysSinceInfection; // probability of death s days after infection in reverse order
  row_vector[SI_CUT] rev_serial_interval; // fixed pre-calculated serial interval using empirical data from Neil in reverse order
  int<lower=1, upper=A> init_A; // age band in which initial cases occur in the first N0 days
}

transformed data {
  vector<lower=0>[M] avg_cntct;
  vector[A] ones_vector_A = rep_vector(1.0, A);
  row_vector[A] ones_row_vector_A = rep_row_vector(1.0, A);
  array[M, N2] int trans_deaths; // reported deaths -- the rows with i > N contain -1 and should be ignored
  
  for( m in 1:M )
  {
    avg_cntct[m] = popByAge[:,m]' * ( cntct_weekdays_mean[m] * ones_vector_A ) * 5./7.;
    avg_cntct[m] += popByAge[:,m]' * ( cntct_weekends_mean[m] * ones_vector_A ) * 2./7.;

    trans_deaths[m,:] = deaths[:,m];
  }
}

parameters {
  vector<lower=0>[M] R0; // R0
  real<lower=0> kappa; // variance parameter for country-specific R0  
  real<lower=0> tau; // prior rate of expected number of cases per day in the first N0 days, for each country
  array[M] real<lower=0> e_cases_N0; // expected number of cases per day in the first N0 days, for each country
  vector[P_RES] beta_res_wkend; // regression coefficients for time varying multipliers on residential contacts on weekends
  vector[P_RES] beta_res_wkday; // regression coefficients for time varying multipliers on residential contacts on weekdays
  vector[P_NONRES] beta_nonres_wkday; // regression coefficients for time varying multipliers on non-residential contacts on weekdays
  real<lower=0> phi; // overdispersion parameter for likelihood model
  array[M] real<lower=0> ifr_noise;
  row_vector<lower=0,upper=1>[A] ifr_age; // probability of death for age band a
}

transformed parameters {
}

model {
  // priors
  tau ~ exponential(0.03);
  e_cases_N0 ~ exponential(1/tau);
  phi ~ normal(0,5);
  beta_res_wkend ~ normal(0,2);
  beta_res_wkday ~ normal(0,2);
  beta_nonres_wkday ~ normal(0,2);
  ifr_noise ~ normal(1,0.1);
  kappa ~ normal(0,0.5);
  R0 ~ normal(3.28, kappa); // citation: https://academic.oup.com/jtm/article/27/2/taaa021/5735319
  ifr_age ~ beta(hyperpara_ifr_age[:,1], hyperpara_ifr_age[:,2]);

  // rstan version
  target += countries_log_dens(trans_deaths, 1, M,
  // cmdstan version
  // target += reduce_sum(countries_log_dens, trans_deaths, 1,
      R0,
      e_cases_N0,
      beta_res_wkend,
      beta_res_wkday,
      beta_nonres_wkday,
      phi,
      ifr_noise,
      N0,
      N2,
      A,
      SI_CUT,
      WKEND_IDX_N,
      wkend_idx,
      avg_cntct,
      covariates_res,
      covariates_nonres,
      cntct_weekends_mean,
      cntct_weekdays_mean,
      rev_ifr_daysSinceInfection,
      ifr_country_scale,
      ifr_age,
      rev_serial_interval,
      epidemicStart,
      N,
      init_A,
      A_AD,
      dataByAgestart,
      map_age,
      deathsByAge,
      map_country,
      ones_vector_A
                       );
  
}

