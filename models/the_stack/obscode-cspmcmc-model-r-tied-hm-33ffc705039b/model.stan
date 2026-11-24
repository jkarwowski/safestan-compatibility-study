functions {
   real A_lamb(vector Al_coef, real Rv, real EBV, int order) {
      int ii;   // 1D index
      real Al;  // the answer
      ii = 1;
      Al = 0;
      for (j in 0:order) {
         for (i in 0:order) {
            if (j+i <= order) {
               Al = Al + Al_coef[ii]*pow(Rv,i)*pow(EBV,j+1);
               ii = ii+1;
            }
         }
      }
      return Al;
   }
}

data {
   int<lower=1> C;             // Number of Cepheid hosts
   cov_matrix[C] Ccov;         // Covariance matrix for Cepheids
   vector[C] DMCeph;           // mean cepheid distances
   int<lower=1> NSNe;          // Number of SNe
   array[NSNe] int<lower=-1> host;  // Host galaxy index
   int<lower=1> NObs;          // Number of observations
   int<lower=1> NFs;           // Number of filters
   int<lower=1> NFs2;          // Number of filters in Alamb matrix
   array[NObs] real ms;              // magnitudes
   array[NObs] real vms;             // error in magnitudes
   array[NSNe] real cs;              // colors
   array[NSNe] real vcs;             // variance in color
   array[NSNe] real st;              // s_BV
   array[NSNe] real est;             // error in s_BV
   array[NSNe] real zcmb;            // CMB redshift
   array[NSNe] real zhel;            // heliocentric redshift
   array[NSNe] real K;               // K-mag
   array[NObs] int sindex;           // SN index
   array[NObs] int findex;           // filter index
   int findex1;                // filter index of first color filter
   int findex2;                // filter index of second color filter
   array[NFs2] int Al_order;         // actual order of poly
   int N_coef;                 // size of array
   array[NFs2] vector[N_coef] Amat;  // the coefficents
   int Nphotsys;               // Number of photometric systems
   array[NSNe] int photsys;          // index of photometric system
   array[Nphotsys] vector[NFs] zperr;// zero-point errors
   real M0;                    // host mass zero-point
   array[NSNe] real sigmaK;          // error in Host Mass estimate
}


transformed data {
   array[NObs] vector[2] mc;
   for (i in 1:NObs) {
      mc[i,1] = ms[i];
      mc[i,2] = cs[sindex[i]];
   }
}


parameters {
   array[NFs] real<lower=-5.0,upper=5.0> a;
   array[NFs] real<lower=-10.0,upper=10.0> b;
   array[NFs] real<lower=-10.0,upper=10.0> c;
   real <lower=0.0,upper=10.0>R;
   array[NFs] real<lower=0.0,upper=1.0> evar;
   real <lower=0.0,upper=10.0>vpec;
   real <lower=40, upper=100> H0;
   array[NSNe] real<lower=-10, upper=10> ct;
   real <lower=-1, upper=1> alpha;
   vector[C] DMhost;
   array[Nphotsys] vector<lower=-5, upper=5>[NFs] zpoff;   // zero-point offsets
}

transformed parameters {
   array[NSNe] real DM;
   array[NObs] cov_matrix[2] covar;
   array[NFs] real Rl;
   for (i in 1:NSNe) {
      if (host[i] < 0) {
         DM[i] = 5.0*log10(((1+zhel[i])/(1+zcmb[i]))*(300000.0/H0)*
                 (zcmb[i] + zcmb[i]*zcmb[i]*0.79)) + 25.0;
      } else {
         DM[i] = DMhost[host[i]];
      }
   }
   for (i in 1:NObs) {
      covar[i][1,1] = vms[i] + evar[findex[i]] + 
                               square(sigmaK[sindex[i]]*alpha);
      if (host[sindex[i]] < 0) {
         covar[i][1,1] = covar[i][1,1] + pow(0.000723*vpec/zcmb[sindex[i]],2);
      }
      covar[i][2,2] = vcs[sindex[i]];
      covar[i][2,1] = 0;
      if (findex[i] == findex1) covar[i][2,1] = covar[i][2,1] + vms[i];
      if (findex[i] == findex2) covar[i][2,1] = covar[i][2,1] - vms[i];
      covar[i][1,2] = covar[i][2,1];
   }
   for (i in 1:NFs) {
      Rl[i] = A_lamb(Amat[i], R, 0.1, Al_order[i])/
           (A_lamb(Amat[findex1], R, 0.1, Al_order[findex1]) - 
            A_lamb(Amat[findex2], R, 0.1, Al_order[findex2]));
   }
}

model {
   vector[2] mct;
   real mass;
   
   DMhost ~ multi_normal(DMCeph, Ccov);

   for (i in 1:NObs) {
      mass = -0.4*(K[sindex[i]] - DM[sindex[i]]) + 1.04;
      mct[1] = (a[findex[i]] - 19) + b[findex[i]]*(st[sindex[i]] - 1) + 
               c[findex[i]]*(st[sindex[i]]-1)*(st[sindex[i]]-1) + 
               Rl[findex[i]]*ct[sindex[i]] + 
               alpha*(mass - M0) + DM[sindex[i]];
      if ( photsys[sindex[i]] > 0) {
         mct[1] = mct[1] + zpoff[photsys[sindex[i]],findex[i]];
      }
      mct[2] = ct[sindex[i]];

      mc[i] ~ multi_normal(mct, covar[i]);
   }
   for (i in 1:Nphotsys) {
      for (j in 1:NFs) {
         zpoff[i,j] ~ normal(0, zperr[i,j]);
      }
   }

}

generated quantities {
   array[NObs] real g_modl; 
   real mass;

   for (i in 1:NObs) {
      mass = -0.4*(K[sindex[i]] - DM[sindex[i]]) + 1.04;
      g_modl[i] = (a[findex[i]] - 19) + b[findex[i]]*(st[sindex[i]] - 1) +
                   c[findex[i]]*(st[sindex[i]]-1)*(st[sindex[i]]-1) +
                   Rl[findex[i]]*ct[sindex[i]] + 
                   alpha*(mass - M0) + DM[sindex[i]];
   }
}
