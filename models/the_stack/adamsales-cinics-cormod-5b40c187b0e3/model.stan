data{
 int<lower=1> p;
 int<lower=1> Npat; // # patects
 array[Npat] row_vector[p] X;


 int<lower=1> Nanx;
 array[Nanx] int<lower=1,upper=Npat> patAnx;
 array[Nanx] real<lower=0> timeAnx;
 array[Nanx] int<lower=1,upper=3> anx;

 int<lower=1> Nhard;
 array[Nhard] int<lower=1,upper=Npat> patHard;
 array[Nhard] real<lower=0> timeHard;
 array[Nhard] int<lower=0,upper=1> hard;

 int<lower=1> Nalc;
 array[Nalc] int<lower=1,upper=Npat> patAlc;
 array[Nalc] real<lower=0> timeAlc;
 array[Nalc] int<lower=1,upper=3> alc;

 int<lower=1> Ndep;
 array[Ndep] int<lower=1,upper=Npat> patDep;
 array[Ndep] real<lower=0> timeDep;
 array[Ndep] int<lower=1,upper=3> dep;

 int<lower=1> Ncig;
 array[Ncig] int<lower=1,upper=Npat> patCig;
 array[Ncig] real<lower=0> timeCig;
 array[Ncig] int<lower=1,upper=3> cig;

 int<lower=1> Nqol;
 array[Nqol] int<lower=1,upper=Npat> patQol;
 array[Nqol] real<lower=0> timeQol;
 array[Nqol] int<lower=1,upper=5> qol;

 int<lower=1> Ncd4;
 array[Ncd4] int<lower=1,upper=Npat> patCd4;
 array[Ncd4] real<lower=0> timeCd4;
 array[Ncd4] real<lower=0> cd4;
}

parameters{
// psychological variables: anx, dep

 array[Npat] vector[4] psych; // random terms: 1= int anx, 2=trend anx, 3=int dep, 4= trend dep
 corr_matrix[4] OmegaPsych;        // prior correlation
 vector<lower=0>[4] tauPsych;      // prior scale
 vector[2] trendPsych; // avg trend: 1=anx 2=dep

 vector[p] betaAnx; //fixed effects
 ordered[2] Canx;

 vector[p] betaDep; //fixed effects
 ordered[2] Cdep;

// substance abuse variables: cig, alc, hard

 array[Npat] vector[6] sub; // random terms: 1,2= int,trend cig, 3,4=int, trend alc, 5,6=int, trend hard
 corr_matrix[6] OmegaSub;        // prior correlation
 vector<lower=0>[6] tauSub;      // prior scale
 vector[3] trendSub; //avg trend 1=cig, 2=alc, 3=hard

 vector[p] betaCig; //fixed effects
 ordered[2] Ccig;

 vector[p] betaAlc; //fixed effects
 ordered[2] Calc;

 vector[p] betaHard; //fixed effects
 real muHard; // avg intercept hard


// cd4

 array[Npat] real alphaCd4;
 array[Npat] real gammaCd4;
 real<lower=0> sig_alphaCd4;
 real<lower=0> sig_gammaCd4;
 real trendCd4; //avg trend
 vector[p] betaCd4; //fixed effects
 real<lower=0> sigCd4;
 real mu_gammaCd4;


// qol

 array[Npat] real alphaQol;
 array[Npat] real gammaQol;
 real<lower=0> sig_alphaQol;
 real<lower=0> sig_gammaQol;
 real trendQol; //avg trend
 vector[p] betaQol; //fixed effects
 ordered[4] Cqol;
 real mu_gammaQol;

// latent regression slopes
 array[3, 2] real betaSub;
 row_vector[4] deltaP;
 row_vector[6] deltaS;
 row_vector[4] etaP;
 row_vector[6] etaS;
 array[2] real etaC;
}

transformed parameters{
 array[Npat] real trendCig;
 array[Npat] real trendAlc;
 array[Npat] real trendHard;
 array[Npat] vector[6] subTot;

 for(i in 1:Npat){
  trendCig[i]=trendSub[1]+betaSub[1,1]*psych[i][1]+betaSub[1,2]*psych[i][3]+sub[i][2];
  trendAlc[i]=trendSub[2]+betaSub[2,1]*psych[i][1]+betaSub[2,2]*psych[i][3]+sub[i][4];
  trendHard[i]=trendSub[3]+betaSub[3,1]*psych[i][1]+betaSub[3,2]*psych[i][3]+sub[i][6];
  subTot[i]=[sub[i][1],trendCig[i],sub[i][3],trendAlc[i],sub[i][5],trendHard[i]]';
 }
}

model{

 // alc, cig, hard
 tauSub ~ cauchy(0, 2.5);
 OmegaSub ~ lkj_corr(6);
 sub ~ multi_normal([0,0,0,0,0,0], quad_form_diag(OmegaSub, tauSub));

 // anx, dep
 tauPsych ~ cauchy(0,2.5);
 OmegaPsych ~ lkj_corr(4);
 psych~multi_normal([0,0,0,0],quad_form_diag(OmegaPsych,tauPsych));

// ordered variables: anx, dep, cig,alc,qol
// psychology variables
 for(i in 1:Nanx){
  anx[i] ~ ordered_logistic(psych[patAnx[i]][1]+(trendPsych[1]+psych[patAnx[i]][2])*timeAnx[i]+X[patAnx[i]]*betaAnx,Canx);
 }
 betaAnx ~ normal(0,1);

for(i in 1:Ndep){
  dep[i] ~ ordered_logistic(psych[patDep[i]][3]+(trendPsych[2]+psych[patDep[i]][4])*timeDep[i]+X[patDep[i]]*betaDep,Cdep);
 }
 betaDep ~ normal(0,1);

// substance abuse variables: cig, alc, hard
 for(i in 1:Ncig){
  cig[i] ~ ordered_logistic(sub[patCig[i]][1]+trendCig[patCig[i]]*timeCig[i]+X[patCig[i]]*betaCig,Ccig);
 }
 betaCig ~ normal(0,1);

 for(i in 1:Nalc){
  alc[i] ~ ordered_logistic(sub[patAlc[i]][3]+trendAlc[patAlc[i]]*timeAlc[i]+X[patAlc[i]]*betaAlc,Calc);
 }
 betaAlc ~ normal(0,1);

 for(i in 1:Nhard){
  hard[i] ~ bernoulli_logit(muHard+sub[patHard[i]][5]+trendHard[patHard[i]]*timeHard[i]+X[patHard[i]]*betaHard);
 }
 betaHard ~ normal(0,1);

// cd4 counts
 for(i in 1:Ncd4){
  cd4[i] ~ normal(alphaCd4[patCd4[i]]+gammaCd4[patCd4[i]]*timeCd4[i]+X[patCd4[i]]*betaCd4,sigCd4);
 }
 for(i in 1:Npat){
  gammaCd4[i] ~ normal(mu_gammaCd4+
   deltaP*psych[i]+
   deltaS*subTot[i],
  sig_gammaCd4);
 }
 deltaP~normal(0,.5);
 deltaS~normal(0,.5);
 alphaCd4 ~ normal(0,sig_alphaCd4);
 betaCd4 ~ normal(0,1);
 mu_gammaCd4 ~ normal(0,1);
 deltaP~normal(0,.5);
 deltaS~normal(0,.5);
 sigCd4~cauchy(0, 2.5);

// QOL
 for(i in 1:Nqol){
  qol[i] ~ ordered_logistic(alphaQol[patQol[i]]+gammaQol[patQol[i]]*timeQol[i]+X[patQol[i]]*betaQol,Cqol);
 }
 for(i in 1:Npat){
  gammaQol[i] ~ normal(mu_gammaQol+
    etaP*psych[i]+
    etaS*subTot[i]+
    etaC[1]*alphaCd4[i]+
    etaC[2]*gammaCd4[i],
  sig_gammaQol);
 }
 alphaQol ~ normal(0,sig_alphaQol);
 betaQol ~ normal(0,1);
 mu_gammaQol ~ normal(0,1);
 etaP~normal(0,.5);
 etaS~normal(0,.5);
 etaC~normal(0,.5);

}