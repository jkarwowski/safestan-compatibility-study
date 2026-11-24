functions {

  // constant density prior on distance
  real constdens_lpdf(real r) {
    real ln_prob;
    if (r<1)
      ln_prob = 2*log(r);
    else
      ln_prob = negative_infinity();
    return ln_prob;
  }

}

data {
  int<lower=2> N;     // number of stars

  // Units:
  //  ra [deg]
  //  dec [deg]
  //  parallax [mas]
  //  pmra [mas/yr]
  //  pmdec [mas/yr]
  array[N] real ra;
  array[N] real dec;
  array[N] vector[3] a;        // parallax, pmra, pmdec
  array[N] cov_matrix[3] C;    // covariance matrix
}

transformed data {
  array[N] matrix[2, 3] M;      // to equitorial rectangular coordinates
  array[N] real ra_rad;
  array[N] real dec_rad;
  for (i in 1:N) {
    ra_rad[i] = ra[i] * pi() / 180.;
    dec_rad[i] = dec[i] * pi() / 180.;
  }

  for(i in 1:N) {
    M[i,1,1] = -sin(ra_rad[i]);
    M[i,1,2] =  cos(ra_rad[i]);
    M[i,1,3] = 0.;
    M[i,2,1] = -sin(dec_rad[i])*cos(ra_rad[i]);
    M[i,2,2] = -sin(dec_rad[i])*sin(ra_rad[i]);
    M[i,2,3] = cos(dec_rad[i]);
  }
}

parameters {
  vector<lower=0>[N] d;                // true distances [kpc]
  vector[3] v0;                        // mean velocity  [km/s]
  vector<lower=0>[3] sigv;             // dispersion     [km/s]
  corr_matrix[3] Omega;                // correlation
}

transformed parameters {
  array[N] vector[3] a_model;

  for(i in 1:N) {
    a_model[i][1] = 1./d[i];
    a_model[i][2] = M[i,1] * v0 / d[i] / 4.74;
    a_model[i][3] = M[i,2] * v0 / d[i] / 4.74;
  }
}

model {
  array[N] matrix[3, 3] D;             // modified covariance matrix

  // priors
  v0 ~ normal(0, 30);
  sigv ~ uniform(0., 50);
  Omega ~ lkj_corr(2);
  for(i in 1:N) {
    d[i] ~ constdens();
  }

  for(i in 1:N) {
    D[i] = C[i];
  }
  for(i in 1:N) {
    D[i,2:3,2:3] = D[i,2:3,2:3]
      + M[i] * quad_form_diag(Omega, sigv) * transpose(M[i]) / d[i]^2 / 4.74^2;
  }

  // likelihood
  for(i in 1:N) {
    a[i] ~ multi_normal(a_model[i], D[i]);
  }

}

generated quantities {
  // Generate data of star i from posterior of v0
  // vi[i] = [pmra, pmdec, rv]
  array[N] vector[3] vi;
  for(i in 1:N) {
    vi[i][1] = M[i,1] * v0 / d[i] / 4.74;
    vi[i][2] = M[i,2] * v0 / d[i] / 4.74;
    vi[i][3] = cos(dec_rad[i])*cos(ra_rad[i])*v0[1] + cos(dec_rad[i])*sin(ra_rad[i])*v0[2] + sin(dec_rad[i])*v0[3];
  }
}
