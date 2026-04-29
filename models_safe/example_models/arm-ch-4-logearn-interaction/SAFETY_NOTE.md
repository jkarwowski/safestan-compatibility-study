# SafeStan Safety Note

Compatibility: major.

Protected data: `earn` is the top-level observed response; the model scores the transformed-data quantity `log_earn = log(earn)`. `N`, `height`, and `male` are context inputs.

Generated files: none.

Reason: SafeStan requires the protected observation to be a top-level data identifier on the left side of exactly one built-in sampling statement. The original likelihood samples transformed data (`log_earn`) rather than a top-level data variable; replacing this with a likelihood directly on `earn` would require a lognormal/Jacobian change and would not preserve the same density. In addition, the parameters `alpha`, `beta`, and `sigma` have no explicit proper priors, and adding such priors would change the posterior. Therefore this cannot be translated with only minor same-density changes.
