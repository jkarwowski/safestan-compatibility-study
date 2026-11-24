data {
  int<lower=0> I; // number of incumbent races
  int<lower=0> J; // number of open races
  int<lower=0> D; // number of races automatically conceded to democrats
  int<lower=0> R; // number of races automatically conceded to republicans
  real expswing; // expected national swing from 2016
  int dfswing; // degrees of freedom of swing in t distribution
  array[I] real expI; // expected result under even national vote for incumbent races
  array[J] real expJ; // expected result under even national vote for open races
  real<lower=0> sdswing; // standard deviation of expectation of national swing from 2016
  real<lower=0> sdI; // expected variance for incumbent races
  real<lower=0> sdJ; // expected variance for open races
}
parameters {
  real swing;
  array[I] real deltaI;
  array[J] real deltaJ;
}
transformed parameters {
  array[I] real resI;
  array[J] real resJ;
  for (i in 1:I) resI[i] = swing + deltaI[i];
  for (j in 1:J) resJ[j] = swing + deltaJ[j];
}
model {
  swing ~ student_t(dfswing, expswing, sdswing);
  for (i in 1:I) deltaI[i] ~ normal(expI[i], sdI);
  for (j in 1:J) deltaJ[j] ~ normal(expJ[j], sdJ);
}
generated quantities {
  int<lower=0> rseats = R;
  int<lower=0> dseats = D;
  for (i in 1:I) {
    if (resI[i] > 0) {
      dseats = dseats + 1;
    } else {
      rseats = rseats + 1;
    }
  }
  for (j in 1:J) {
    if (resJ[j] > 0) {
      dseats = dseats + 1;
    } else {
      rseats = rseats + 1;
    }
  }
}
