# SafeStan Safety Note

Compatibility: major.

Protected data: `y` in the original model.

Generated files: none.

Reason: the likelihood for `y` is a custom Poisson-hurdle likelihood implemented with `target +=` inside a loop and branches on `y[n]`. The protected observation is also read in `transformed data` to define the truncation point `U = max(y)`. Replacing this with SafeStan sampling statements would require a substantive rewrite of the likelihood/interface, such as splitting zeros and positive counts or introducing an external truncation value, and would not be a minor same-density translation.
