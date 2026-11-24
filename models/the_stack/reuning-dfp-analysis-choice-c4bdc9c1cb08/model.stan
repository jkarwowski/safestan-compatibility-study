data {
  int N; // Number of Respondent-Questions
  int K; // Number of Candidates 
  int J; // Number of Questions
  
  array[N] int set; // Indexes the question (or set of comparisons)
  array[20, J] int first; // Indexes first candidate in comparison for each question
  array[20, J] int second; // Indexes first candidate in comparison for each question
  array[N] int choice; // What comparison is identified 

  array[N] int vid; // Indexes voters
  
  int M; // Number of voters
  array[M] int race; //Race of voter m 
  array[M] int age; //Age of voter m
  array[M] int gender; //Gender of voter m
  array[M] int ideo; //Ideology of voter m
  array[M] int educ; //Education of voter m
  array[M] int inc; //Income of voter m


}

parameters {

  vector[K] alpha; // Intercept for Candidate K 
  
  // Used for funnel trick
  real<lower=0> race_sigma; 
  array[3] vector[K] race_raw;
  
  real<lower=0> age_sigma;
  array[5] vector[K] age_raw;
  
  real<lower=0> gender_sigma;
  array[2] vector[K] gender_raw;
  
  real<lower=0> educ_sigma;
  array[4] vector[K] educ_raw;
  
  real<lower=0> ideo_sigma;
  array[5] vector[K] ideo_raw;
  
  real<lower=0> inc_sigma;
  array[6] vector[K] inc_raw;
}

transformed parameters {
  array[3] vector[K] race_beta; // Random intercept on race category for candidate K,
  array[5] vector[K] age_beta; 
  array[2] vector[K] gender_beta;
  array[4] vector[K] educ_beta;
  array[5] vector[K] ideo_beta;
  array[6] vector[K] inco_beta;


  // Transformation means that prior is: race_beta[k, 1] ~ Normal(0, race_sigma);
  for(ii in 1:3){
    race_beta[ii] = race_raw[ii] * race_sigma;
  }

  for(ii in 1:2){
    gender_beta[ii] = gender_raw[ii] * gender_sigma;
  }
  
  
  for(ii in 1:4){
    educ_beta[ii] = educ_raw[ii] * educ_sigma;
  }
  
  for(ii in 1:5){
    age_beta[ii] = age_raw[ii] * age_sigma;
    ideo_beta[ii] = ideo_raw[ii] * ideo_sigma;

  }
  for(ii in 1:6){
    inco_beta[ii] = inc_raw[ii] * inc_sigma;
  }
  
}

model {
  
  
  alpha[1] ~ normal(0, .1); // Pins an alpha to ensur identification (honestly not sure how necesary this is). 
  alpha[2:K] ~ normal(0, 1);
  
  for(ii in 1:2){
    gender_raw[ii] ~ normal(0, 1);
  }
  
  for(ii in 1:3){
    race_raw[ii] ~ normal(0, 1);
  }
  
  for(ii in 1:4){
    educ_raw[ii] ~ normal(0, 1);
  }

  for(ii in 1:5){
    age_raw[ii] ~ normal(0, 1);
    ideo_raw[ii] ~ normal(0, 1);

  }
  
  for(ii in 1:6){
    inc_raw[ii] ~ normal(0, 1);
  }
  
  
  race_sigma ~ normal(0, 1);
  age_sigma ~ normal(0, 1);
  gender_sigma ~ normal(0, 1);
  inc_sigma ~ normal(0, 1);
  ideo_sigma ~ normal(0, 1);
  educ_sigma ~ normal(0, 1);

  
  {
    vector[K] theta;
    
    for(ii in 1:N){
      
      // Creates the preferences for each candidate for voter vid[ii]
      // This is an inefficient loop 
      theta = alpha + race_beta[race[vid[ii]]] + age_beta[age[vid[ii]]] 
                    + gender_beta[gender[vid[ii]]] + inco_beta[inc[vid[ii]]] 
                    + ideo_beta[ideo[vid[ii]]] + educ_beta[educ[vid[ii]]] ;

      // Selection of pair Best-Worst is then given by the distance between 
      // each possible comparison for that voter. 
      // Remember choice[ii] is limited between 1 and 20 as it is 
      // identifying which comparison is made. 
      // Each question had 5 candidates so 5*4=20 possible comparisons 
      choice[ii] ~ categorical_logit(theta[first[,set[ii]]] 
                                      - theta[second[,set[ii]]] );
      
    }
  }




  
}

