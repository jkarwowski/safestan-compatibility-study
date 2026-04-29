# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed capture-history variable scored by the likelihood. `m`, `nind`, and `n_occasions` are context inputs, not protected observations.

Generated files: none.

Reason: the likelihood is not expressible as a minor SafeStan rewrite. The model scores indexed elements `y[i, t]` inside loops, uses `y` in `transformed data` to compute `first` and `last` before any observation statement, and also adds parameter-dependent likelihood factors through constant sampling statements such as `1 ~ bernoulli(phi[i, t - 1])` and `1 ~ bernoulli(chi[i, last[i]])`. SafeStan requires each protected top-level data variable to be observed exactly once with a plain built-in sampling statement, and sampling statements may not target constants or indexed projections. Preserving this Cormack-Jolly-Seber capture-history likelihood would require a substantive re-expression or augmentation of the marginalized latent-state likelihood, not a mechanical same-density SafeStan translation.
