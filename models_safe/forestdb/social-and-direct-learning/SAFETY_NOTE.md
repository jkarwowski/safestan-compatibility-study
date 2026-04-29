# SafeStan Safety Note

Compatibility: major.

Protected data: `likelihood` is the observed data entering the manual likelihood; `H` and `N` are context/configuration inputs.

Generated files: none.

Reason: the model uses `target += log_sum_exp(...)` to add a marginalized likelihood term involving `likelihood` and `hypothesis_weight`. SafeStan forbids arbitrary `target +=` scoring, and there is no equivalent built-in Stan sampling statement with a plain top-level observed left-hand side that represents this generic precomputed mixture likelihood. Rewriting it would require a substantive change, such as introducing a different observation representation or a custom/user-defined distribution, which is outside the SafeStan-compatible subset.
