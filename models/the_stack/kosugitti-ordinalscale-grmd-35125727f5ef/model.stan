data{
  int L;      //Data Length
  int C;      //number of Categories
  int N;      //number of Subject
  int M;      //number of Items
  int D;      //number of Dimensions
  array[L] int Pid; //Index of Subject
  array[L] int Jid; //Index of Items
  array[L] int<lower=1,upper=C> val;
}

parameters{
  array[M] vector<lower=0>[D] a;
  array[M] ordered[C-1] b_rev;
  array[N] vector[D] theta;
}

transformed parameters{
  array[N, M] vector<lower=0,upper=1>[C-1] prob;
  array[N, M] simplex[C] Pijk;
  array[M] vector[C-1] b;

  //ordered and decreasing
  for(m in 1:M){
    for(c in 1:(C-1)){
      b[m,c] = b_rev[m,C-c];
    }
  }

  for(n in 1:N){
    for(m in 1:M){
      for(c in 1:(C-1)){
        prob[n,m,c] = inv_logit(1.7*a[m]'*theta[n]+b[m,c]);
      }
    }
  }

  for(n in 1:N){
    for(m in 1:M){
      for(c in 1:C){
        if(c == 1){
          Pijk[n,m,c] = 1 - prob[n,m,c];
        }else if(c == C){
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
    for(d in 1:D){
      theta[n,d] ~ normal(0,1);
    }
  }
  for(m in 1:M){
    for(d in 1 :D){
      a[m,d] ~ lognormal(0,sqrt(0.5));
    }
    for(c in 1:(C-1)){
      b_rev[m,c] ~ normal(0,2);
    }
  }
}

