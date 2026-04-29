# SafeStan Safety Note

Compatibility: major.

Protected data: `score1`.

Generated files: none.

Reason: the observed response `score1` is scored once with the built-in `normal_id_glm` likelihood, and the predictor data `party`, `z1`, and `z2` are ordinary context inputs. However, the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before it is used. Adding proper priors for these parameters would change the posterior, while the original implicit flat/half-flat priors are not a minor SafeStan-compatible rewrite. Therefore no same-density SafeStan translation is produced.
