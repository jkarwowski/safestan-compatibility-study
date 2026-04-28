# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation sequence `y` is scored through a marginalized hidden Markov model forward algorithm using indexed `categorical_lpmf(...)` calls and a final `target += log_sum_exp(last)`. SafeStan requires each protected data variable to appear exactly once as a plain identifier on the left side of a built-in sampling statement. There is no built-in Stan distribution for this marginalized HMM sequence likelihood, and replacing the forward algorithm with SafeStan sampling statements would require a substantive model rewrite or a change to the likelihood.
