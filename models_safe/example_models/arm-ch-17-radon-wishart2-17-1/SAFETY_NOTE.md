# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation likelihood is `y ~ normal(y_hat, sigma)`, so `y` is the protected interface variable. However, the model is not SafeStan-compatible under the required parameter discipline. The parameter `sigma` has no built-in prior sampling statement, and adding one would change the posterior because its current constraint only gives an improper implicit prior. In addition, `B_raw_temp ~ multi_normal(...)` appears inside a loop and scores the same top-level parameter repeatedly, which SafeStan disallows. Rewriting these terms into exactly one built-in prior per parameter would require a substantive density/model change rather than a minor mechanical translation.
