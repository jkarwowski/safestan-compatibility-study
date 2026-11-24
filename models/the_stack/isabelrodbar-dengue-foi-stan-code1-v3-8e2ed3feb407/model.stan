data {
  int <lower=0> A; //the number of age classes
  int <lower=0> Ag; //the max age
  int <lower=0> T; //the number of observation time points
  int <lower=0> Y; // number of years represented in the data
int <lower=0> L; // number of lambdas represented in the data
  array[A, T] int<lower=0> I; //the number of cases reported at each time point for each age group
  array[A, T] int<lower=0> C; // the total population at each time point for each age group
  array[Ag, T] int<lower=0> ind_lambda; // indices for lambdas
  array[A] int<lower=0> ind_age; // indices for ages

}


parameters {
array[L] real logit_lambda; //  specific hazards
array[T] real logit_phi; // logit of reporting rates

}

transformed parameters {
  array[Ag, T] real lambda_year;
array[Ag-1, T] real cum_lambda;
array[Ag-1, T] real susc;
array[Ag-1, T] real mono;
array[A, T] real mono_dat;
array[A, T] real poi_rate;
array[L] real lambda; // yearly specific hazards
array[T] real phi; // reporting rates 


for(i in 1:L) {
lambda[i]=inv_logit(logit_lambda[i]);
}

for(i in 1:T) {
phi[i]=inv_logit(logit_phi[i]);
}


for (i in 1:T) {
    for (j in 1:Ag) {
        //print(ind_lambda[j,i])
    	lambda_year[j,i] = lambda[ind_lambda[j,i]] ;
	}
 }

//print(ind_lambda);
for (i in 1:T) {
    cum_lambda[1,i]=lambda_year[2,i];
    for (j in 2:(Ag-1)) {
    	cum_lambda[j,i]=cum_lambda[j-1, i] + lambda_year[j+1,i];
					 }
			}

for( i in 1:T) {
     for (j in 1:Ag-1) {
     	 susc[j,i]=exp(-4*cum_lambda[j,i]);
	 mono[j,i]=4*susc[j,i]*(exp(cum_lambda[j,i])-1);
	 }
}

for (i in 1:T) {
    for (j in 1:A) {
    	mono_dat[j,i]=mono[ind_age[j], i];
	}
}

for (i in 1:T) {
    for (j in 1:A) {
    	poi_rate[j,i]=mono_dat[j,i]*3*lambda[ind_lambda[1,T-i+1]]*phi[T-i+1]*C[j,i];
	}
}
}

model {
for(i in 1:L) {
 logit_lambda[i]~normal(0,1000);
 }

for(i in 1:T) {
logit_phi[i] ~ normal(0,1000);
}

for (i in 1:T) {
    for (j in 1:A) {
    	I[j,i]~ poisson(poi_rate[j,i]);
	}
}

}













