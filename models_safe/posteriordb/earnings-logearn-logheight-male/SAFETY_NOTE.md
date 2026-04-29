# SafeStan Safety Note

Compatibility: major.

Protected data choice: the original likelihood scores `log_earn`, a transformed-data value computed as `log(earn)`.

Generated files: none.

Reason: the parameters `beta` and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to be scored exactly once by a built-in prior before use. Adding priors for the unconstrained `beta` vector or the lower-bounded `sigma` would replace the model's implicit improper flat priors and would be a substantive density change, not a minor same-density rewrite.
