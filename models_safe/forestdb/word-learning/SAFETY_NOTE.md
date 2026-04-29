# SafeStan Safety Note

Compatibility: major.

Protected data: no SafeStan-compatible protected data interface can represent the current likelihood directly. The data matrix `likelihood` is used inside a manual marginalized likelihood factor.

Generated files: none.

Reason: the model uses `target += log_sum_exp(lp)` to add a custom marginalized likelihood term depending on `hypothesis_weight` and the data matrix `likelihood`. SafeStan forbids direct `target +=` scoring, and replacing this factor with built-in sampling statements would require introducing a different observed variable or otherwise substantively changing the likelihood/interface. The Dirichlet prior on `hypothesis_weight` is compatible, but the custom marginal likelihood is not a minor same-density rewrite.
