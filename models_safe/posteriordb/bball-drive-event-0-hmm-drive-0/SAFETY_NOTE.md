# SafeStan Safety Note

Compatibility: major.

Protected data: `u`, `v`.

Generated files: none.

Reason: the observations `u` and `v` are scored through a marginalized hidden Markov model forward algorithm using explicit `exponential_lpdf(...)` calls and `target += log_sum_exp(...)`. SafeStan forbids direct `target +=` scoring and requires protected observations to be scored exactly once by built-in sampling statements. Replacing this marginalized latent-state likelihood with SafeStan-compatible sampling statements would require a substantive model rewrite and would not be a minor same-density translation.
