# SafeStan Safety Note

Compatibility: major.

Protected data: the model observes `sqrt_dif`, a transformed-data vector deterministically computed from `score_1 - score_2`.

Generated files: none.

Reason: the likelihood is written for `sqrt_dif`, which is not a top-level data variable, so a SafeStan version would at least require a protected top-level deterministic observation. More importantly, the parameters `b`, `sigma_a`, and `sigma_y` are used in the model without any sampling statement/prior. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the original posterior/log density, and the implicit improper flat priors on these unbounded or half-bounded parameters cannot be represented as density-neutral built-in sampling statements. Therefore this cannot be translated with only minor same-density changes.
