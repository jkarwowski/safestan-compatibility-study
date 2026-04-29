# SafeStan Safety Note

Compatibility: major.

Protected data choice: `k` is the observed data being scored by the binomial likelihood; `m` and `nmax` are context/configuration inputs.

Generated files: none.

Reason: the model marginalizes over an unknown discrete number of surveys `n` by computing `binomial_lpmf(k | n, theta)` for each possible `n`, storing the pieces in transformed parameters, and then adding `target += log_sum_exp(lp_parts)`. SafeStan forbids manual `target +=` scoring and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing this marginalized discrete mixture with SafeStan sampling statements would require a substantive model rewrite and cannot be done as a minor same-density translation.
