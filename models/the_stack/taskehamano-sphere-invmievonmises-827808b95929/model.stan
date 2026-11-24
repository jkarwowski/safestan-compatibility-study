functions {
    real inv_trans_APF(real theta, real mu, real nu, real lambda){
        real t ;
        real ft ;
        real err ;
        int count ;
        count = 0 ;
        // Small nu works with Newton's method
        if ((abs(nu) <= 0.5) || (abs(lambda) <= 0.5)){
            t = theta ;
            ft = t - nu * sin(t-mu) + lambda * pow(sin(t-mu - nu * sin(t-mu)), 2) - theta ;
            err = abs(ft) ;
            while(err > 1e-8){
                t = t - (ft / ((1 + 2 * lambda * sin(t-mu - nu  * sin(t-mu)) * cos(t-mu - nu * sin(t-mu)))* (1 - nu * cos(t-mu)))) ;
                ft = t - nu * sin(t-mu) + lambda * pow(sin(t-mu - nu * sin(t-mu)), 2) - theta ;
                err = abs(ft) ;
                count += 1 ;
                if (count >= 30){
                    break ;
                }
            }
        // Large nu only works with bisection method
        }else{
            real t1 ;
            real t2 ;
            t = (-pi() + pi()) / 2 ;
            ft = t - nu * sin(t-mu) + lambda * pow(sin(t-mu - nu * sin(t-mu)), 2) - theta ;
            err = abs(ft) ;
            while(err > 1e-8){
                if (ft < 0){
                    t1 = t ;
                }else{
                    t2 = t ;
                }
                t = (t1 + t2) / 2 ;
                ft = t - nu * sin(t-mu) + lambda * pow(sin(t-mu - nu * sin(t-mu)), 2) - theta ;
                err = abs(ft) ;
                count += 1 ;
                if (count >= 30){
                    break ;
                }
            }
        }
        return t ;
    }

    real invmievon_mises_mixture_lpdf(real R, int K, vector a, vector mu, vector kappa, vector nu, vector lambda) {
        vector[K] lp;
        real alpha1 ;
        for (k in 1:K){
            alpha1 = modified_bessel_first_kind(1, kappa[k]) / modified_bessel_first_kind(0, kappa[k]) ;
            lp[k] = log(a[k]) + von_mises_lpdf(inv_trans_APF(R, mu[k], nu[k], lambda[k]) | mu[k], kappa[k]) - log(1 - nu[k] * alpha1) ;
        }
        return log_sum_exp(lp) ;
    }
}

data {
    int I ;
    int S ;
    int L ;
    array[I] int<lower=1, upper=L> LOCATION ;
    array[I] int<lower=1, upper=S> SUBJECT ;
    array[I] int<lower=0> DEPTH ;
    int<lower=1> K ; // number of mixed distribution
}

transformed data {
    vector<lower=-pi(), upper=pi()>[I] RADIAN ;
    vector<lower=0.0>[K] A; //hyperparameter for dirichlet distribution

    RADIAN = -pi() + (2.0 * pi() / L) * (to_vector(LOCATION) - 1) ;
    A = rep_vector(50.0/K, K) ;
}

parameters {
    simplex[K] alpha ;
    array[K] unit_vector[2] O ;
    // Unconstrained concentration parameter
    array[S] vector[K] kappa_uncon ;
    // skewness parameter
    array[S] vector<lower=-1.0, upper=1.0>[K] nu ;
    // peakness parameter as raw
    array[S] vector<lower=-1.0, upper=1.0>[K] lambda_raw ;
}

transformed parameters{
    vector[K] ori ;
    array[S] vector<lower=0, upper=4.0>[K] kappa ;
    // peakness parameter
    array[S] vector<lower=-1.0, upper=1.0>[K] lambda ;

    // convert unit vector
    for (k in 1:K){
        ori[k] = atan2(O[k][1], O[k][2]) ;
    }
    for (s in 1:S){
        lambda[s] = lambda_raw[s] .* (1 - abs(nu[s])) ;
        // Add upper bound to kappa using alpha (see 'Lower and Upper Bounded Scalar' in Stan manual)
        kappa[s] = log(4) ./ (2 * alpha) .* inv_logit(kappa_uncon[s]) ;
    }
}

model {
    alpha ~ dirichlet(A) ;
    for(s in 1:S){
        alpha .* kappa[s] ~ student_t(2.5, 0, 0.2025) ;
        // Jacobian adjustment for parameter transformation (see 'Lower and Upper Bounded Scalar' in Stan manual)
        target += log(log(4) ./ (2 * alpha)) + log_inv_logit(kappa_uncon[s]) + log1m_inv_logit(kappa_uncon[s]) ;
        nu[s] ~ normal(0, 1) ;
    }
    for(i in 1:I){
        target += DEPTH[i] * invmievon_mises_mixture_lpdf(RADIAN[i] | K, alpha, ori, kappa[SUBJECT[i]], nu[SUBJECT[i]], lambda[SUBJECT[i]]) ;
    }
}

generated quantities {
    array[S] vector<lower=1.0>[K] PTR ;
    array[S] vector<lower=1.0>[K] wPTR ;
    vector<lower=1.0>[S] mwPTR ;
    vector[I] log_lik ;
    real log_lik_sum ;

    for(s in 1:S){
        // Fold change of max p.d.f. to min p.d.f.
        PTR[s] = exp(2 * kappa[s]) ;
        wPTR[s] = exp(2 * alpha .* kappa[s]) ;
        mwPTR[s] = sum(wPTR[s]) ;
    }
    for(i in 1:I){
        log_lik[i] = DEPTH[i] * invmievon_mises_mixture_lpdf(RADIAN[i] | K, alpha, ori, kappa[SUBJECT[i]], nu[SUBJECT[i]], lambda[SUBJECT[i]]) ;
    }
    log_lik_sum = sum(log_lik) ;
}
