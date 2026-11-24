data {
  int I; // サンプル数
  int N; // 患者人数
  int T; // 時刻インデックスの数
  array[I] int<lower=1, upper=N> PersonID; // サンプルの人ID
  array[I] int<lower=1, upper=T> TimeID; // サンプルの時間ID
  array[T] real Time; // 時刻インデックスごとの時刻値
  array[I] real Y; // サンプルごとの薬剤血中濃度
  int T_new;
  array[T_new] real Time_new;
}

parameters {
    vector[N] log_a;
    vector[N] log_b;

    real a0;
    real b0;
    real<lower=0> sigma_a;
    real<lower=0> sigma_b;
    real<lower=0> sigma;
}

transformed parameters {
    vector[N] a;
    vector[N] b;
    matrix[N, T] mu;

    a = exp(log_a);
    b = exp(log_b);

    for (t in 1:T) {
        for (n in 1:N) {
            mu[n, t] = a[n]*(1 - exp(-b[n].*Time[t]));
        }
    }
}

model {
    log_a ~ normal(a0, sigma_a);
    log_b ~ normal(b0, sigma_b);

    for (i in 1:I)
        Y[i] ~ normal(mu[PersonID[i], TimeID[i]], sigma);
}

generated quantities {
    array[N, T_new] real y_new;
    for (n in 1:N) {
        for (t in 1:T_new) {
            y_new[n, t] = normal_rng(a[n]*(1 - exp(-b[n]*Time_new[t])), sigma);
        }
    }
}