# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ poisson_log(...)`, so `y` is the protected interface variable. However, the model also defines the spatial prior for `phi` using manual log-density manipulation, `target += -0.5 * dot_self(...)`, and additional soft sum-to-zero constraints of expressions inside a loop. SafeStan forbids `target +=`, requires each parameter to have exactly one built-in prior sampling statement, and does not allow parameter priors on non-identifier expressions such as `sum(phi[...])`. Replacing this ICAR construction with a built-in multivariate prior or a reparameterization would be a substantive density/model rewrite rather than a minor mechanical translation. The model also contains a `reject()` in transformed data and would require prior/likelihood reordering, but the custom ICAR prior is the blocking issue.
