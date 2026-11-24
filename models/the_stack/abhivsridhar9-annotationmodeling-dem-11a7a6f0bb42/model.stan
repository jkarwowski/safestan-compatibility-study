
data {
    // observed data
    int<lower=0> NDATA;
    int<lower=0> NITEMS;
    int<lower=0> NUSERS;
    array[NDATA] int<lower=1, upper=NITEMS> items;
    array[NDATA] int<lower=1, upper=NUSERS> u1s;
    array[NDATA] int<lower=1, upper=NUSERS> u2s;
    int<lower=0, upper=NUSERS> n_gold_users; // first n_gold_users assumed to be gold
    real gold_user_err;
    array[NDATA] real distances;

    // hyperparameters
    real<lower=0> uerr_prior_scale;
    real<lower=0> diff_prior_scale;

    real<lower=0> uerr_prior_loc_scale;
    real<lower=0> diff_prior_loc_scale;
}
transformed data {
    array[NITEMS] matrix[NUSERS, NUSERS] distance_matrices;
    array[NITEMS] vector[NUSERS] active_users_1hot;
    array[NITEMS, NUSERS] int active_users; // for each item, user ids working on item until zero
    array[NITEMS] int n_itemlabels;
    for (i in 1:NITEMS) {
        distance_matrices[i] = rep_matrix(0, NUSERS, NUSERS);
        active_users_1hot[i] = rep_vector(0, NUSERS);
        for (u in 1:NUSERS) active_users[i, u] = 0;
    }
    for (n in 1:NDATA) {
        int i = items[n];
        int u1 = u1s[n];
        int u2 = u2s[n];
        real dist = distances[n];
        distance_matrices[i, u1, u2] = dist;
        distance_matrices[i, u2, u1] = dist;
        active_users_1hot[i, u1] = 1;
        active_users_1hot[i, u2] = 1;
    }
    for (i in 1:NITEMS) {
        int c = 1;
        for (u in 1:NUSERS) {
            if (active_users_1hot[i, u] > 0) {
                active_users[i, c] = u;
                c += 1;
            }
        }
        n_itemlabels[i] = c - 1;
    }
}
parameters {
    // real<lower=0> uerr_prior_loc;
    // real<lower=0> diff_prior_loc;
    // real<lower=0> uerr_prior_scale;
    // real<lower=0> diff_prior_scale;
    vector<lower=0>[NUSERS] uerr;
    vector<lower=0>[NITEMS] diff;
}
transformed parameters {
    matrix[NITEMS, NUSERS] label_logprobs;
    matrix[NITEMS, NUSERS] label_logprobabilities = rep_matrix(-666, NITEMS, NUSERS);
    matrix[NITEMS, NUSERS] label_probabilities = rep_matrix(0, NITEMS, NUSERS);
    for (i in 1:NITEMS) {
        int nlabels = n_itemlabels[i];
        vector[nlabels] probs;
        if (nlabels == 0) continue;
        for (n1 in 1:nlabels) {
            real log_prob_n1 = 0;
            int u1 = active_users[i, n1];
            real scale = uerr[u1] * diff[i] + 0.01;
            for (n2 in 1:nlabels) {
                int u2 = active_users[i, n2];
                if (u1 != u2) {
                    real dist = distance_matrices[i, u1, u2];
                    // real scale = uerr[u2] * diff[i];
                    log_prob_n1 += normal_lpdf(dist | 0, scale);
                }
            }
            label_logprobs[i, n1] = log_prob_n1;
        }
        probs = softmax(label_logprobs[i, 1:nlabels]');
        for (n in 1:nlabels) {
            int u = active_users[i, n];
            label_logprobabilities[i, u] = label_logprobs[i, n];
            label_probabilities[i, u] = probs[n];
        }
    }
}
model {
    // uerr ~ normal(uerr_prior_loc, uerr_prior_scale);
    // diff ~ normal(diff_prior_loc, diff_prior_scale);
    // uerr_prior_loc ~ normal(0, uerr_prior_loc_scale);
    // diff_prior_loc ~ normal(0, diff_prior_loc_scale);

    for (i in 1:NITEMS) {
        int nlabels = n_itemlabels[i];
        if (nlabels == 0) continue;
        target += log_sum_exp(label_logprobs[i, 1:nlabels]);
    }
}
generated quantities {
    matrix<lower=0>[NITEMS, NUSERS] dist_from_truth = 1 - label_probabilities;
    array[NITEMS] matrix[NUSERS, NUSERS] distance_matrices_data = distance_matrices;
    array[NITEMS, NUSERS] int active_users_data = active_users;
    array[NITEMS] int n_itemlabels_data = n_itemlabels;
}
