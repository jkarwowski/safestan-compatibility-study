# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is scored with a truncated normal likelihood, `y[n] ~ normal(mu, sigma) T[ , U]`. The truncation contributes parameter-dependent normalization terms to the log density. SafeStan requires protected observations to be observed with plain top-level sampling statements and does not allow censored/truncated target adjustments or manual replacement with `target +=`. Replacing this with an untruncated normal likelihood would change the posterior. The model also has an implicit improper prior on `mu`, which cannot be fixed without inventing a prior.
