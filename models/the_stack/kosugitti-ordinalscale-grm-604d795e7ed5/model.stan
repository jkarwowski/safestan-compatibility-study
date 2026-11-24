data{
  int L;      //Data Length
  int C;      //number of Categories
  int N;      //number of Subject
  int M;      //number of Items
  array[L] int Pid; //Index of Subject
  array[L] int Jid; //Index of Items
  array[L] int<lower=1,upper=C> val;
}

parameters{
  array[M] real<lower=0> a;   //Discriminant Parameter
  array[M] ordered[C-1] b;   //Difficulty Parameter
  array[N] real theta;
}

transformed parameters{
  array[M, C] real loc;          //Location parameter
  array[N, M] vector<lower=0,upper=1>[C-1] prob;
  array[N, M] simplex[C] Pijk;

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
