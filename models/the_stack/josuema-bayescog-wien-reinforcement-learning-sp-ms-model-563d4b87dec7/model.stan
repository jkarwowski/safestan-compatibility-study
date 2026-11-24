data {
  int<lower=1> nSubjects;
  int<lower=1> nTrials;
  array[nSubjects, nTrials] int<lower=1,upper=2> choice;     
  array[nSubjects, nTrials] real<lower=-1, upper=1> reward; 
}

transformed data {
  vector[2] initV;  // initial values for V
  initV = rep_vector(0.0, 2);
}

parameters {
  real<lower=0,upper=1> lr;
  real<lower=0,upper=3> tau;  
}

model {
  for (s in 1:nSubjects) {
    vector[2] v; 
    real pe;    
    v = initV;
    
    for (t in 1:nTrials) {
      // complete the foo-loop here
      choice[s,t] ~ categorical_logit( tau * v );
      pe = reward[s,t] - v[choice[s,t]];      
      v[choice[s,t]] = v[choice[s,t]] + lr * pe; 
    }
  }    
}
