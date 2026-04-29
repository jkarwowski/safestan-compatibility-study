# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (observed through the transformed-data standardized value `y_std`). `x`, `z`, and `N` are context inputs.

Generated files: none.

Reason: the model's likelihood and branch-specific prior contributions are implemented by manual log-density accumulation with `target += log_sum_exp(log_p)`, using `normal_lpdf` and `gamma_lpdf` terms inside a marginalized two-branch mixture. SafeStan forbids `target +=` and requires protected observations and parameter priors to be expressed as built-in sampling statements with single-use discipline. Replacing this marginalized mixture with SafeStan sampling statements would require a substantive model rewrite and would change the density structure rather than being a minor mechanical translation.
