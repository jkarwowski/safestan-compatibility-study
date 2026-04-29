# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_sum_exp(...)` word likelihood with an equivalent built-in `categorical` sampling statement for the top-level protected variable `y`. The categorical probabilities are computed as the same mixture over `atom[k]` weighted by `local_weight[doc[n], k]`. The Dirichlet priors over `local_weight` and `atom` were written as vectorized top-level sampling statements rather than looped indexed sampling statements. No data values were changed or added. `doc` is treated as a context index, not as protected observed data.
