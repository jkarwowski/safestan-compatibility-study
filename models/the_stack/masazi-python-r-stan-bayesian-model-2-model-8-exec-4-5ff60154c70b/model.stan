data {
    int N; // Person
    int C; // コース
    int I; // 授業

    array[N] real<lower=0, upper=1> Score;
    array[N] int<lower=0, upper=1> A;

    array[I] int<lower=1, upper=N> PID;
    array[I] int<lower=1, upper=C> CID;
    array[I] real<lower=0, upper=1> W;
    array[I] int<lower=0, upper=1> Y;
}

parameters {
    real b1; // 授業ごと
    real b2; // アルバイトの好き嫌い
    real b3; // スコア
    real b4; // 天気
    array[N] real bp; // 学生ごと
    array[C] real bc; // コースごと
}

transformed parameters {
    array[I] real x;
    array[I] real xw;
    array[N] real xp;
    array[C] real xc;
    array[I] real q;
    for (n in 1:N) {
        xp[n] = b2*A[n] + b3*Score[n] + bp[n];
    }
    for (c in 1:C) {
        xc[c] = bc[c];
    }
    for (i in 1:I) {
        xw[i] = b4 * W[i];
        x[i] = b1 + xp[PID[i]] + xc[CID[i]] + xw[i];
        q[i] = inv_logit(x[i]);
    }
}

model {
    for (i in 1:I) {
        Y[i] ~ bernoulli(q[i]);
    }
}

