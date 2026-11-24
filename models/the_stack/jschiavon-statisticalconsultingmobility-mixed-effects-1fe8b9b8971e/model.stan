data {
  int <lower=1> M; // number of countries
  int <lower=1> P; // number of covariates
  int <lower=1> N0; // number of days for which to impute infections
  array[M] int<lower=1> N; // days of observed data for country m. each entry must be <= N2
  int<lower=1> N2; // days of observed data + # of days to forecast
  array[N2, M] int cases; // reported cases
  array[N2, M] int deaths; // reported deaths -- the rows with i > N contain -1 and should be ignored
  matrix[N2, M] f; // h * s
  array[M] matrix[N2, P] covariate; // array con le matrici delle covariate:
        // M è il numero di regioni
        // P il numero di covariate
        // L'array è di tipo Covariate[m, n, p], quindi ci sono M array 
        // in cui ciascuno contiene una matrice NxP di covariate
  array[M] int EpidemicStart; //index at which epidemic started for each country
  array[N2] real SI; // fixed pre-calculated SI using emprical data from Neil
}

parameters {
  array[M] real<lower=0> mu; // è R_0m
  vector[P] alpha; // the hier term, effetto fisso
  array[M] vector[P] beta; // the hier term, specifico per regioni [Array di M vettori lunghi P]
  
  real<lower=0> gamma; // varianza di beta
  real<lower=0> kappa; // varianza di R0
  
  array[M] real<lower=0> y;
  real<lower=0> psi;
  real<lower=0> tau;
}

transformed parameters {
    real convolution;
    matrix[N2, M] prediction = rep_matrix(0, N2, M);
    matrix[N2, M] E_deaths  = rep_matrix(0, N2, M);
    matrix[N2, M] Rt = rep_matrix(0, N2, M);
    
    for (m in 1:M){
      prediction[1:N0,m] = rep_vector(y[m], N0); // learn the number of cases in the first N0 days
      
      Rt[, m] = mu[m] * 2 * inv_logit(covariate[m] * beta[m]); // Intervento della mobilità

      for (i in (N0+1):N2) {
        convolution=0;
        for(j in 1:(i-1)) {
          convolution += prediction[j, m] * SI[i-j]; // Correctd 22nd March
        }
        prediction[i, m] = Rt[i,m] * convolution;
      }
      
      E_deaths[1, m]= 1e-9;
      for (i in 2:N2){
        E_deaths[i,m]= 0;
        for(j in 1:(i-1)){
          E_deaths[i,m] += prediction[j,m] * f[i-j,m];
        }
      }
    }
}

model {
  // modello per il contagio
  tau ~ exponential(0.03); // distribuzione dei tempi
  y ~ exponential(1.0 / tau);

  // modello per R con covariate
  kappa ~ gamma(1, 1); // varianza di R0 tra regioni
  mu ~ normal(2.7, kappa); // distribuzione di R0 tra regioni ---> cambiare
  
  gamma ~ gamma(1, 1); // effetto casuale: varianza dei beta_mk
  alpha ~ std_normal(); // prior su effetto fisso
  
  for(m in 1:M){
    beta[m] ~ normal(alpha, gamma); // prior su effetto casuale
  }
  
  // modello per le morti
  psi ~ std_normal(); // sarebbe psi nell'articolo
  for(m in 1:M){
    for(i in EpidemicStart[m]:N[m]){
       deaths[i,m] ~ neg_binomial_2(E_deaths[i,m], 5 * psi); 
    }
   }
}
