# SafeStan Safety Note

Compatibility: major.

Protected data choice: `log_lik` is the data-dependent quantity used in the likelihood contribution; `N`, `S`, and `prior_concentration` are context/hyperparameter inputs.

Generated files: none.

Reason: the model uses manual likelihood scoring via `target += log_sum_exp(lp)` inside a marginalized latent-state mixture over the rows of `log_lik`. SafeStan forbids arbitrary `target +=` scoring, and replacing this calculation with protected-data sampling statements over built-in Stan distributions would require a substantive change to the model/density rather than a minor mechanical rewrite.
