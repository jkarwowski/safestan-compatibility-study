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
  array[N, M] vector[C] Pijk;
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
