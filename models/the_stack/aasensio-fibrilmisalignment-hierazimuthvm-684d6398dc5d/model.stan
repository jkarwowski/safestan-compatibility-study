data {
    int<lower=0> N; // number of pixels
    array[N] real QI_II; // QI/II
    array[N] real UI_II; // UI/II    
    array[N] real angle;
    real beta; // value of beta
    array[N] real<lower=0> sigma; // value of noise
}

parameters {
    array[N] real<lower=-pi(),upper=pi()> phi;
    array[N] real<lower=0, upper=1500.0> Bp;
    real<lower=-pi()/2,upper=pi()/2> muPhi;
    real<lower=0.0, upper=7.0> muBp;
    real<lower=0.0, upper=50.0> kPhi;
    real<lower=0.0> sigmaBp;
    // real<lower=0.0, upper=1.0> theta;
}

model {    
    array[N] real QSyn;
    array[N] real USyn;

    sigmaBp ~ inv_gamma(0.001,0.001);
    kPhi ~ inv_gamma(0.001,0.001);
                
    Bp ~ lognormal(muBp, sigmaBp);

    phi ~ von_mises(muPhi, kPhi);

    for (j in 1:N) {
        QSyn[j] = beta * pow(Bp[j], 2.0) * cos(2*phi[j] + 2.0*angle[j]);
        USyn[j] = beta * pow(Bp[j], 2.0) * sin(2*phi[j] + 2.0*angle[j]);      
    }
            
    QI_II ~ normal(QSyn, sigma);
    UI_II ~ normal(USyn, sigma);

}
