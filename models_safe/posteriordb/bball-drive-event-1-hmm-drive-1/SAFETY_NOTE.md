# SafeStan Safety Note

Compatibility: major.

Protected data: `u`, `v`.

Generated files: none.

Reason: the observations `u` and `v` are scored through a marginalized hidden Markov model forward algorithm implemented with `normal_lpdf(...)` calls and `target += log_sum_exp(...)`. SafeStan forbids arbitrary `target +=` scoring and requires protected data to be observed exactly once with built-in sampling statements. Replacing this forward-algorithm likelihood with SafeStan-compatible sampling statements would require a substantive model rewrite or a different likelihood representation, not a minor same-density translation. The prior `target +=` statements could be mechanically rewritten, but the marginalized HMM likelihood cannot.
