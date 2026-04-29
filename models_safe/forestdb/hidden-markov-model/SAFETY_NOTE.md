# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed sequence/modelled interface in the original HMM.

Generated files: none.

Reason: the likelihood for `y` is computed by a marginalized hidden-state forward algorithm using `categorical_lpmf(...)` terms and a final `target += log_sum_exp(...)`. SafeStan forbids direct `target +=` scoring and cannot express this HMM marginal likelihood as a single built-in sampling statement for the top-level protected data. Rewriting it would require a substantive change to the model or likelihood rather than a minor same-density translation.
