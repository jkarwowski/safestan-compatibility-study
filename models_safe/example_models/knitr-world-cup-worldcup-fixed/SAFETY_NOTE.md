# SafeStan Safety Note

Compatibility: major.

Protected data: the observed likelihood is applied to `sqrt_dif`, a transformed-data quantity deterministically computed from `score_1` and `score_2`. No SafeStan protected variables are emitted for this major case.

Generated files: none.

Reason: although the transformed observation `sqrt_dif` could mechanically be supplied as a deterministic top-level protected data variable, the model has parameters `b`, `sigma_a`, and `sigma_y` with no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for these parameters would change the posterior/log density because the original model uses implicit improper flat priors for them. Therefore an equivalent SafeStan translation would require a substantive density change.
