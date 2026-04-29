# SafeStan Safety Note

Compatibility: major.

Protected data: `marr` in the original model. `n_occasions` is context data.

Generated files: none.

Reason: the model observes the m-array with row-wise indexed multinomial sampling statements inside a loop (`marr[t] ~ multinomial(pr[t])`), while SafeStan requires each protected top-level data variable to be sampled exactly once with a plain identifier. The protected data are also read in `transformed data` before observation to compute `r`. More importantly, the parameter `sigma` has only an implicit improper positive-uniform prior; SafeStan requires every parameter to have exactly one built-in prior before use, and adding a proper prior for `sigma` would change the posterior. Therefore a SafeStan-compatible version would require substantive model/density changes rather than a minor mechanical rewrite.
