data{
  int L;      //Data Length
  int C;      //number of Categories
  int N;      //number of Subject
  int M;      //number of Items
  int Pid[L]; //Index of Subject
  int Jid[L]; //Index of Items
  int<lower=1,upper=C> val[L];
}

parameters{
  real<lower=0> a[M];   //Discriminant Parameter
  ordered[C-1]  b[M];   //Difficulty Parameter
  real          theta[N];
}

transformed parameters{
  real loc[M,C];          //Location parameter
  vector<lower=0,upper=1>[C-1] prob[N,M];
  simplex[C]  Pijk[N,M];

  //convert difficulty to location
  for(m in 1:M){
    for(c in 1:C){
      if(c==1){
        loc[m,c] = b[m,c];
      }else if(c==C){
        loc[m,c] = b[m,c-1];
      }else{
        loc[m,c] = (b[m,c]+b[m,c-1])/2;
      }
    }
  }

  //logistic model
  for(n in 1:N){
    for(m in 1:M){
      for(c in 1:(C-1)){
        prob[n,m,c] = inv_logit(a[m]*(theta[n]-loc[m,c]));
      }
    }
  }

  for(n in 1:N){
    for(m in 1:M){
      for(c in 1:C){
        if(c==1){
          Pijk[n,m,c] = 1-prob[n,m,c];
        }else if(c==C){
          Pijk[n,m,c] = prob[n,m,c-1] - 0;
        }else{
          Pijk[n,m,c] = prob[n,m,c-1] - prob[n,m,c];
        }
      }
    }
  }

}


model{
  //likelihood
  for(l in 1:L){
    val[l] ~ categorical(Pijk[Pid[l],Jid[l]]);
  }
  //prior
  for(n in 1:N){
    theta[n] ~ normal(0,1);
  }
  for(m in 1:M){
    a[m] ~ lognormal(0,sqrt(0.5));
    for(c in 1:(C-1)){
      b[m,c] ~ normal(0,2);
    }
  }
}
