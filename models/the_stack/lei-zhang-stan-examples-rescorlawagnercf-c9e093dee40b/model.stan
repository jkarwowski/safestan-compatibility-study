// Hierarchical Rescorla-Wagner model w/ counterfactual feedback
// Assumes each participant must learn the appropriate SR contingencies
// for N stimuli across T trials (where T can vary per participant) and
// both chosen (c) and unchosen (u) are updated with feedback

data {

    // Metadata
    int N;              // Number of subjects
    array[N] int T;           // Number of trials (per subject)

    // Data
    array[N, max(T)] int X;    // Stimulus per subject/trial
    array[N, max(T)] int Y;    // Response per subject/trial
    array[N, max(T)] int R;    // Outcome  per subject/trial

}
transformed data {

    int S = 4;          // Number of stimuli
    int A = 3;          // Number of actions

    array[A, 2] int ix = { {2, 3}, {1, 3}, {1,2} };

}
parameters {

    // Group-level parameters
    vector[3] mu_pr;
    vector<lower=0>[3] sigma;

    // Individual-level parameters
    vector[N] beta_pr;    // Inverse temperature
    vector[N] eta_c_pr;   // Learning rate (chosen)
    vector[N] eta_u_pr;   // Learning rate (unchosen)

}
transformed parameters {

    // Individual-level parameters (scaled)
    vector<lower=0,upper=20>[N] beta;
    vector<lower=0,upper=1>[N] eta_c;
    vector<lower=0,upper=1>[N] eta_u;

    for (i in 1:N) {
        beta[i] = Phi_approx(mu_pr[1] + sigma[1] * beta_pr[i]) * 20;
        eta_c[i] = Phi_approx(mu_pr[2] + sigma[2] * eta_c_pr[i]);
        eta_u[i] = Phi_approx(mu_pr[3] + sigma[3] * eta_u_pr[i]);
    }

}
model {

    // Group-level priors
    mu_pr ~ normal(0, 1);
    sigma ~ normal(0, 1);

    // Individual-level priors
    beta_pr ~ normal(0, 1);
    eta_c_pr ~ normal(0, 1);
    eta_u_pr ~ normal(0, 1);

    // Main loop
    for (i in 1:N) {

        // Initialize Q-table per participant
        array[S] vector[A] Q;
        for (s in 1:S){ Q[s] = rep_vector(0, A); }

        for (j in 1:T[i]) {

            // Likelihood of choice
            Y[i,j] ~ categorical_logit( beta[i] * Q[X[i,j]] );

            // Compute RPE and update (chosen)
            Q[X[i,j], Y[i,j]] += eta_c[i] * (R[i,j] - Q[X[i,j], Y[i,j]]);

            // Compute RPE and update (unchosen)
            Q[X[i,j], ix[Y[i,j]]] += eta_u[i] * ((1-R[i,j]) - Q[X[i,j], ix[Y[i,j]]]);

        }

    }

}
generated quantities {

    vector[3] mu;              // Scaled group-level parameters
    array[N, max(T)] real log_lik;    // Log-likelihood of choice per subject/trial

    mu[1] = Phi_approx(mu_pr[1]) * 20;
    mu[2] = Phi_approx(mu_pr[2]);
    mu[3] = Phi_approx(mu_pr[3]);

    // Main loop
    for (i in 1:N) {

        // Initialize Q-table per participant
        array[S] vector[A] Q;
        for (s in 1:S){ Q[s] = rep_vector(0, A); }

        for (j in 1:T[i]) {

            // Likelihood of choice
            log_lik[i,j] = categorical_logit_lpmf( Y[i,j] | beta[i] * Q[X[i,j]] );

            // Compute RPE and update (chosen)
            Q[X[i,j], Y[i,j]] += eta_c[i] * (R[i,j] - Q[X[i,j], Y[i,j]]);

            // Compute RPE and update (unchosen)
            Q[X[i,j], ix[Y[i,j]]] += eta_u[i] * ((1-R[i,j]) - Q[X[i,j], ix[Y[i,j]]]);

        }

    }

}
