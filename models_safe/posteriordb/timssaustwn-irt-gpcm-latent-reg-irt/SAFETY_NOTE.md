# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed item-response vector scored by the likelihood.

Generated files: none.

Reason: the likelihood is implemented by manual `target += pcm(y[n], ...)` scoring inside a loop, where `pcm` is a user-defined function wrapping a `categorical_lpmf` calculation. SafeStan forbids `target +=`, rejects user-defined likelihood paths in sampling statements, and requires each protected observation to be scored exactly once with a built-in distribution on a plain top-level left-hand side. The model also reads `y` in `transformed data` before observation to compute item category structure, and uses another manual `target += normal_lpdf(beta | 0, 3)` prior on a transformed parameter. Replacing these pieces would require a substantive re-expression of the likelihood/prior structure rather than a minor mechanical SafeStan translation.
