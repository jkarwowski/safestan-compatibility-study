data{
 int<lower=1> Nanx;
 int<lower=1> Nsubj; // # subjects
 array[Nanx] int<lower=1,upper=Nsubj> subjAnx;
 array[Nanx] real<lower=0> timeAnx;
 array[Nanx] int<lower=1,upper=3> anx;
 int<lower=1> p;
 array[Nsubj] row_vector[p] X;

 int<lower=1> Nsub;
 array[Nsub] int<lower=1,upper=Nsubj> subjSub;
 array[Nsub] real<lower=0> timeSub;
 array[Nsub] int<lower=0,upper=1> sub;

 int<lower=1> Nalc;
 array[Nalc] int<lower=1,upper=Nsubj> subjAlc;
 array[Nalc] real<lower=0> timeAlc;
 array[Nalc] int<lower=0,upper=3> alc;

 int<lower=1> Ndep;
 array[Ndep] int<lower=1,upper=Nsubj> subjDep;
 array[Ndep] real<lower=0> timeDep;
 array[Ndep] int<lower=0,upper=3> dep;

}

parameters{
 vector[p] betaAnx; //fixed effects
 vector[p] betaSub; //fixed effects
 vector[p] betaAlc; //fixed effects
 vector[p] betaDep; //fixed effects

 ordered[2] Canx;
 ordered[2] Cdep;
 ordered[2] Calc;

 corr_matrix[8] Omega;        // prior correlation
 vector<lower=0>[8] tau;      // prior scale
 vector[4] trends; // anx, sub, alc, dep
 real alphaSub;

 array[Nsubj] vector[8] rand; // random terms: 1 2= int trend anx, 3 4= int trend sub, 5 6 alc, 7 8 dep
}

model{

 vector[8] zeros;

 vector[Nanx] anxHat;
 vector[Ndep] depHat;
 vector[Nalc] alcHat;
 vector[Nsub] subHat;

 zeros = to_vector(rep_array(0,8));

  for(i in 1:Nanx){
   anxHat[i]=rand[subjAnx[i]][1]+(trends[1]+rand[subjAnx[i]][2])*timeAnx[i]+X[subjAnx[i]]*betaAnx;
 }
 for(i in 1:Ndep){
  depHat[i] = rand[subjDep[i]][7]+(trends[4]+rand[subjDep[i]][8])*timeDep[i]+X[subjDep[i]]*betaDep;
 }
 for(i in 1:Nalc){
  alcHat[i] = rand[subjAlc[i]][5]+(trends[3]+rand[subjAlc[i]][6])*timeAlc[i]+X[subjAlc[i]]*betaAlc;
 }
 for(i in 1:Nsub){
  subHat[i] = alphaSub+rand[subjSub[i]][3]+(trends[2]+rand[subjSub[i]][4])*timeSub[i]+X[subjSub[i]]*betaSub;
 }


 tau ~ cauchy(0, 2.5);
 Omega ~ lkj_corr(2);
 rand ~ multi_normal(zeros, quad_form_diag(Omega, tau));

 betaAnx ~ std_normal();
 betaDep ~ std_normal();
 betaAlc ~ std_normal();
 betaSub ~ std_normal();
 alphaSub~ std_normal();
 trends~std_normal();

 anx~ordered_logistic(anxHat,Canx);
 dep~ordered_logistic(depHat,Cdep);
 alc~ordered_logistic(alcHat,Calc);
 sub~bernoulli_logit(subHat);

}

