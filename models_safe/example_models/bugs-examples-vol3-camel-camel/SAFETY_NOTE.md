# SafeStan Safety Note

Compatibility: major.

Protected data: none. The program has no top-level `data` block; the observed camel values are hard-coded inside the `model` block rather than supplied through a protected data interface.

Generated files: none.

Reason: the model uses forbidden manual scoring, `target += -1.5 * log(determinant(Sigma))`, for an improper/custom covariance prior. It also scores local constructed values `Y[n] ~ multi_normal(mu, Sigma)` inside a loop, where `Y` mixes hard-coded observations and latent missing-value parameters; SafeStan sampling statements must target only top-level protected data variables or top-level parameters. Replacing this with SafeStan-compatible built-in priors/observations would require a substantive re-expression of the missing-data likelihood and covariance prior, not a minor same-density rewrite.
