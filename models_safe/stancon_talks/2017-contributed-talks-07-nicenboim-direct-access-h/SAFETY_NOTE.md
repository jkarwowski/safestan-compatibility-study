# SafeStan Safety Note

Compatibility: major.

Protected data: `winner` and `RT`.

Generated files: none.

Reason: the likelihood for the observed choice and response-time data is implemented as a custom joint log density in `da(...)` and added with `target += log_lik`. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once using built-in sampling statements. Replacing this marginalized/custom likelihood with SafeStan-compatible sampling statements would require a substantive model rewrite and cannot be done as a minor same-density translation.
