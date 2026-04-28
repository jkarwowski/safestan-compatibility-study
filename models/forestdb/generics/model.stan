// ForestDB translation: Generics
data {
  int<lower=1> S;
  int<lower=1> U;
  int<lower=1> Q;
  int<lower=1, upper=U> observed_utterance;
  simplex[S] state_prior;
  simplex[Q] qud_weight;
  array[S, U] int<lower=0, upper=1> semantics;
  matrix[S, U] utility;
}
parameters {
  real<lower=0> alpha;
  vector[S] state_bias;
}
model {
  vector[S] listener_lp;

  alpha ~ lognormal(0, 0.5);
  state_bias ~ normal(0, 1);

  for (s in 1:S) {
    vector[U] speaker_logits;
    for (u in 1:U) {
      real semantic_bonus = semantics[s, u] ? 0 : negative_infinity();
      speaker_logits[u] = alpha * utility[s, u] + semantic_bonus;
    }
    listener_lp[s] = log(state_prior[s]) + state_bias[s]
                     + log_softmax(speaker_logits)[observed_utterance];
  }
  target += log_sum_exp(listener_lp);
}
generated quantities {
  simplex[S] listener_state;
  {
    vector[S] listener_lp;
    for (s in 1:S) {
      vector[U] speaker_logits;
      for (u in 1:U) {
        real semantic_bonus = semantics[s, u] ? 0 : negative_infinity();
        speaker_logits[u] = alpha * utility[s, u] + semantic_bonus;
      }
      listener_lp[s] = log(state_prior[s]) + state_bias[s]
                       + log_softmax(speaker_logits)[observed_utterance];
    }
    listener_state = softmax(listener_lp);
  }
}
