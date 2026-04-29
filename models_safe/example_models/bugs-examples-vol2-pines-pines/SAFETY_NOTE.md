# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the response enters the manually computed marginal likelihood through `y_std`). `x`, `z`, and `N` are context inputs.

Generated files: none.

Reason: the model uses a marginalized model-selection likelihood assembled with explicit `normal_lpdf`/`gamma_lpdf` terms in `transformed parameters` and then scored via `target += log_sum_exp(log_py)`. SafeStan forbids arbitrary `target +=` scoring and requires protected observations and parameters to be scored by direct built-in sampling statements. Replacing this marginalized likelihood and its branch-specific priors/pseudo-priors with SafeStan sampling statements would require a substantive statistical rewrite rather than a minor mechanical same-density translation.
