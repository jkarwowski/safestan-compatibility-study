# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation is scored through a manual `target += log_sum_exp(listener_lp)` term that marginalizes over latent listener states and indexes a `log_softmax` value by `observed_utterance`. SafeStan forbids arbitrary `target +=` scoring and requires protected data to be observed exactly once as a top-level identifier on the left side of a built-in sampling statement. Replacing this with a built-in categorical likelihood would introduce normalization over utterances and would not preserve the original density, especially because the existing `state_bias` contribution induces a parameter-dependent normalizing factor. Therefore a SafeStan version would require a substantive likelihood/model rewrite rather than a minor mechanical translation.
