# SafeStan Safety Note

Compatibility: major.

Protected data: `u`, `v`.

Generated files: none.

Reason: the model implements a marginalized hidden Markov model likelihood with a forward algorithm and manual `target += log_sum_exp(...)` scoring, with emission log densities for the observed data `u` and `v` embedded inside the dynamic program. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once by plain built-in sampling statements. Replacing this marginalized HMM likelihood with SafeStan sampling statements would require a substantive model/algorithm rewrite, not a minor same-density translation.
