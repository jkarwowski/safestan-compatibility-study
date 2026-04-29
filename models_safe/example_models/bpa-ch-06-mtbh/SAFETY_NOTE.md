# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed data variable scored by the likelihood in the original program.

Generated files: none.

Reason: the likelihood is implemented with manual `target +=` terms, including a marginalized inclusion/absence mixture using `log_sum_exp(...)` for species with all-zero detections. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once by a built-in sampling statement with a plain top-level data variable on the left-hand side. Replacing this marginalized custom likelihood with SafeStan sampling statements would require a substantive statistical rewrite, not a minor mechanical translation. The protected data `y` is also used in transformed data/transformed parameters before any possible observation statement, which would require additional restructuring but does not remove the main custom-likelihood obstacle.
