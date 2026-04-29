# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed response, used through the transformed-data standardization `y_std`. `x` and `z` are predictor/context inputs.

Generated files: none.

Reason: the model's log density is a marginalized two-model mixture implemented with manual `target += log_sum_exp(log_py)` scoring and direct `normal_lpdf`/`gamma_lpdf` terms. The branch-specific likelihoods, priors, and pseudo-priors are combined inside the mixture rather than appearing as one built-in observation statement for protected data and one built-in prior statement per parameter. Rewriting this into SafeStan sampling statements would require a substantive change to the marginalized latent-model algorithm and parameter-prior structure, not a minor same-density translation.
