# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observation is the top-level data variable `y`, scored once as `y ~ bernoulli(p)`. However, the model is not SafeStan-compatible because several parameters do not have explicit built-in prior sampling statements. In particular the positive scale parameters `sigma`, `sigma_age`, `sigma_edu`, `sigma_state`, `sigma_region`, and `sigma_age_edu` lack priors; some are used as prior scales before any prior of their own, and `sigma` is unused. SafeStan requires every parameter to appear in exactly one built-in prior sampling statement before use. Adding proper priors or removing parameters would change the original posterior/log density, so this cannot be repaired by a minor same-density rewrite.
