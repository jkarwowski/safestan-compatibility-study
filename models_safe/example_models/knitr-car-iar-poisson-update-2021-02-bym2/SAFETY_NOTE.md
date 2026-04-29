# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the modelled interface variable, because it is the top-level data variable scored by the likelihood statement `y ~ poisson_log(...)`.

Generated files: none.

Reason: the likelihood statement for `y` is SafeStan-shaped, and the ordering of parameter priors before the likelihood would be a minor mechanical issue. However, the spatial prior for `phi` is implemented as a user-defined distribution, `phi ~ standard_icar(edges)`, backed by user-defined `_lpdf` functions and a `reject()` call. SafeStan requires parameter priors to be built-in distributions and rejects user-defined distributions and `reject()`. Replacing this ICAR penalty with built-in sampling statements would require a substantive prior rewrite and could change the density/normalization or validity conditions, so no minor same-density SafeStan translation is produced.
