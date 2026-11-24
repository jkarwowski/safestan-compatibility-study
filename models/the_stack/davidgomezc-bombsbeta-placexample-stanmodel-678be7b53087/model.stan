

functions{

    array[] real PLacExample_ODEs(real t, array[] real y, array[] real p, array[] real x_r, array[] int x_i){

      // Inputs
      real IPTG = x_r[1]; 


      // Parameters
      real alpha1 = p[1]; 
      real Vm1 = p[2]; 
      real h1 = p[3]; 
      real Km1 = p[4]; 
      real d1 = p[5]; 
      real alpha2 = p[6]; 
      real d2 = p[7]; 
      real Kf = p[8]; 
      real sc_molec = p[9]; 


      // ODEs
      array[4] real dInd_dt;

      real Cit_mrna = y[1]; 
      real Cit_foldedP = y[2]; 
      real Cit_fluo = y[3]; 
      real Cit_AU = y[4]; 


      dInd_dt[1] = alpha1+Vm1*(IPTG^h1/(Km1^h1+IPTG^h1))-d1*Cit_mrna; 
      dInd_dt[2] = alpha2*Cit_mrna-(d2+Kf)*Cit_foldedP; 
      dInd_dt[3] = Kf*Cit_foldedP-d2*Cit_fluo; 
      dInd_dt[4] =  sc_molec*dInd_dt[3]; 


      // Results
      return dInd_dt;

    }


    vector SteadyState(vector init, vector p, array[] real x_r, array[] int x_i){


      vector[4] alp;

      // Parameters and Inputs
      real alpha1 = p[1]; 
      real Vm1 = p[2]; 
      real h1 = p[3]; 
      real Km1 = p[4]; 
      real d1 = p[5]; 
      real alpha2 = p[6]; 
      real d2 = p[7]; 
      real Kf = p[8]; 
      real sc_molec = p[9]; 

      real IPTG = x_r[1]; 


      // Equations

      alp[1] =  (alpha1 + Vm1*(IPTG^h1/(Km1^h1+IPTG^h1)))/d1;; 
      alp[2] =  (alpha2*alp[1])/(Kf+d2);; 
      alp[3] =  (Kf*alp[2])/d2;; 
      alp[4] =  sc_molec*alp[3];; 


      // Results
      return alp;
                

    }

}
    

data {

    // Observables
    int m; // Total number of data series
    int stslm; // Maximum number of rows for all the observable matrices
    array[1, m] int stsl; // Number of elements at each time series for each series m
    array[stslm, m] int sts; // Sampling times for each series m
    int obser;//-> Introduce this so we have all the data in one same array (easier generalisation). Work on generalisation in case different experiments have different obsevables?
    array[1, obser] int obSta; // -> This variable will be to know which are the observable states

    array[stslm, m, obser] real Means; // ---> General arrays of means and errors
      array[stslm, m, obser] real Erros;

    // Inputs
    int elm; // Number of rows in the matrices for IPTG and aTc, half for the inputs and -1 for the total number of events
    int tml; // Maximum length of the rows for the sampling times matrix
    array[1, m] int Nsp; // Number of event switching points (including final time) times for each series m
    array[tml, m] real ts; // Time series for each serie m
    array[1, m] int tsl; // Length of sampling time series per serie m

    int nindu; // -> Number of inducers/stimuly
    array[nindu, m] real preInd; // Values of inputs for each serie m for the ON incubation

    array[(elm*nindu), m] real inputs; // Input values for each event ordered as IPTG, aTc, IPTG, aTc, ...

    array[(elm+1), m] int evnT; // Event change time points for each serie m
    array[4, m] real Y0us; // Y0 vectors



    // Prior parameters
    int numN;
    vector[numN] mera; // Mean
    matrix[numN,numN] cora; // Covariance matrix
    
}


    

transformed data {

    int nParms = 9; // Number of parameters of the model //--------> Introduce number in generation of script
    int Neq = 4; // Total number of equations of the model //-----> Introduce number in generation of script
    array[0] int x_i; // Empty x_i object (needs to be defined)
    array[(elm*nindu), m] real x_r=inputs; // Input values for each event ordered as IPTG, aTc, IPTG, aTc, ...
    array[Neq, m] real ivss = Y0us; // Initial experimental values for the calculation of the steady state ordered as LacI+RFP, TetR+GFP -------------------------> Carefull to how I define this
    array[nindu, m] real pre; // Input values during the 24h incubation ordered as IPTG, aTc

    for(i in 1:m){
        for(k in 1:nindu){
          pre[k,i] = preInd[k,i]; //-> If people only give a Y0 value, this will be NO needed
        };
    };

}
    

parameters {

real<lower=-2,upper=2> alpha1; 
real<lower=-2,upper=2> Vm1; 
real<lower=-2,upper=2> h1; 
real<lower=-2,upper=2> Km1; 
real<lower=-2,upper=2> d1; 
real<lower=-2,upper=2> alpha2; 
real<lower=-2,upper=2> d2; 
real<lower=-2,upper=2> Kf; 
real<lower=-2,upper=2> sc_molec; 


}

    

transformed parameters {

array[nParms] real theta; 
theta[1] = ((alpha1)*(0.1237403))+0.2475194; 
theta[2] = ((Vm1)*(0.11405))+0.2669; 
theta[3] = ((h1)*(1.1))+2.7; 
theta[4] = ((Km1)*(2.0))+6.0; 
theta[5] = ((d1)*(0.055575))+0.11885000000000001; 
theta[6] = ((alpha2)*(1.6408500000000001))+3.525; 
theta[7] = ((d2)*(0.06121005))+0.1224799; 
theta[8] = ((Kf)*(0.002425))+0.01685; 
theta[9] = ((sc_molec)*(2.49975))+5.0005; 


}

    

model {

  // Intermediate parameters
  int i; // Increasing index for the inputs
  vector[Neq] ing; // Vector that will include the solution of the algebraic solution for the steady state of the model
  
  array[Neq, m] real Y0; // Initial values for the ODEs variables at the first event
  array[stslm, m, obser] real yhat; // ---> Generall array to include all the observables (easier generalisation)

  // Reparameterised priors definition
alpha1 ~ normal(0,1); 
Vm1 ~ normal(0,1); 
h1 ~ normal(0,1); 
Km1 ~ normal(0,1); 
d1 ~ normal(0,1); 
alpha2 ~ normal(0,1); 
d2 ~ normal(0,1); 
Kf ~ normal(0,1); 
sc_molec ~ normal(0,1); 


  // Likelihood
  for (j in 1:m){

    array[Neq] real ivst; // Initial value of the states
    array[(tsl[1,j]), Neq] real y_hat; // Object to include the ODEs solutions for each state

    // Calculation of Y0

    ing = SteadyState(to_vector(ivss[,j]), to_vector(theta), pre[,j], x_i);
    for(g in 1:Neq){
      Y0[g,j] = ing[g];
    };


    i = 1;

    // Loop (over the number of events/inputs) to solve the ODE for each event stopping the solver and add them to the final object y_hat

    for (q in 1:Nsp[1,j]-1){
      int itp = evnT[q,j];  // Initial time points of each event
      int lts = num_elements(ts[(evnT[q,j]+1):(evnT[q+1,j]+1),j]);  // Length of the time series for each event
      array[lts, Neq] real part1; // Temporary object that will include the solution of the ODE for each event at each loop

      // Calculation of the solution for the ODEs where for events that are not the first one. The time series starts one minute before the original point of the time serie overlaping with the last point of the previous event with same state values at the time
      if (q == 1){
        ivst = Y0[,j];
        part1 = integrate_ode_bdf(PLacExample_ODEs,ivst,itp,ts[(evnT[q,j]+1):(evnT[q+1,j]+1),j],theta,to_array_1d(inputs[i:(i+(nindu-1)),j]), x_i, 1.0e-9, 1.0e-9, 1e7);
      }
      else{
        part1 = integrate_ode_bdf(PLacExample_ODEs, ivst,(itp-1e-7),ts[(evnT[q,j]+1):(evnT[q+1,j]+1),j],theta,to_array_1d(inputs[i:(i+(nindu-1)),j]), x_i, 1.0e-9, 1.0e-9, 1e7);
      }

      // Modification of the initial state values for the next event
      ivst = part1[lts];
      // Increase index for inputs
      i=i+nindu;

      // Introduction of the result of part1 into the object y_hat
      for (y in (itp+1):(itp+lts)){
        y_hat[(y),]=(part1)[(y-itp),];
      };
    };

    // Likelihood definition (residuals) at each sampling time

    for (t in 1:stsl[1,j]){ //----> General form
        yhat[t,j,1] = 3*y_hat[(sts[t,j]+1),4]; 
        Means[t,j,1] ~ normal(yhat[t,j,1],Erros[t,j,1]);
    }

  }
}

    