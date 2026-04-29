# SafeStan Safety Note

Compatibility: major.

Protected data: `X` is the observed detection-count matrix; `J`, `K`, `n`, and `S` act as sizes/configuration for the original marginalized occupancy likelihood.

Generated files: none.

Reason: the likelihood is a marginalized latent occupancy/availability model implemented with manual `target +=` log-probability terms, custom helper log-probability functions, and control flow that inspects `X[i, j]` before adding either the observed or unobserved-site contribution. SafeStan requires protected observations to be scored exactly once by a built-in distribution using a plain top-level data variable on the left side of `~`; this zero-inflated/marginalized occupancy likelihood has no direct built-in Stan sampling statement equivalent. The model also uses manual `target +=` scoring for the multivariate species-level prior and a prior on an expression, which would require additional restructuring. Producing a SafeStan-compatible version would therefore require a substantive model rewrite, not a minor same-density translation.
