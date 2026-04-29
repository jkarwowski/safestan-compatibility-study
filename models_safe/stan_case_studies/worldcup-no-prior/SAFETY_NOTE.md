# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `sqrt_dif`, a `transformed data` value deterministically computed from top-level data `score_1` and `score_2`. No SafeStan protected variable is emitted because the scored quantity is not a top-level data variable.

Generated files: none.

Reason: the likelihood is written for a transformed observation (`sqrt_dif ~ student_t(...)`) rather than a top-level protected data variable. Making this SafeStan-compatible would require changing the data interface to include a new transformed observation, not merely a top-level deterministic copy/reshape. In addition, `sigma_a` and `sigma_y` have no explicit priors; adding proper built-in priors for these positive parameters would change the posterior density. Therefore the original density cannot be represented by a minor same-density SafeStan rewrite.
