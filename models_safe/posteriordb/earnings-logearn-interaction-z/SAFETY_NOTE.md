# SafeStan Safety Note

Compatibility: major.

Protected data: the model observes `log_earn`, a transformed-data value computed as `log(earn)` from the top-level data variable `earn`. `height`, `male`, and `N` are context inputs.

Generated files: none.

Reason: the model cannot be translated to SafeStan with only minor same-density changes. The likelihood is placed on a transformed-data response rather than a plain top-level protected data variable, and the latent parameters `beta` and `sigma` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use; adding proper priors for unconstrained `beta` or positive `sigma` would change the original posterior/log density.
