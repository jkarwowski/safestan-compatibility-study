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
  vector[C]  Pijk[N,M];
  for(m in 1:M){
    loc[m,1] = 0.0;
    for(c in 2:C){
      loc[m,c] = b[m,(c-1)];
    }
  }

  for(n in 1:N){
    for(m in 1:M){
      for(c in 1:C){
        Pijk[n,m,c] = 0;
        for(c2 in 1:c){
          Pijk[n,m,c] = Pijk[n,m,c] + (a[m] * (theta[n] - loc[m,c2]));
        }
      }
    }
  }

}

model{
  //likelihood
  for(l in 1:L){
    val[l] ~ categorical(softmax(Pijk[Pid[l],Jid[l]]));
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
