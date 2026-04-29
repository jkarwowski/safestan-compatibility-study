# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood is for `log10_earn`, a transformed-data vector computed deterministically as `log10(earn)`.

Generated files: none.

Reason: the observed quantity is not a top-level data variable, which could only be fixed by adding a deterministic top-level `log10_earn` data field. More importantly, the parameters `beta` and `sigma` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use; adding priors here would change the posterior/log density because the original model uses implicit improper flat priors. Therefore this model cannot be translated to SafeStan with only a minor same-density rewrite.
