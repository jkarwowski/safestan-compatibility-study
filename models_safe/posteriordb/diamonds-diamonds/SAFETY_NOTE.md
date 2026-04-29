# SafeStan Safety Note

Compatibility: major.

Protected data: `Y` would be the protected response, because it is the top-level data variable scored by the likelihood `normal_id_glm_lpdf(Y | Xc, Intercept, b, sigma)`.

Generated files: none.

Reason: the likelihood for `Y` is gated by the top-level data flag `prior_only`. SafeStan requires every protected data variable to be scored exactly once, with a plain built-in sampling statement, before other uses; protected-data observation cannot be conditionally omitted unless all branches have identical sampling effects. Rewriting by always observing `Y`, or by specializing/removing the `prior_only` mode, would change the model interface/log density rather than being a minor mechanical translation. The `target +=` prior terms are mechanically rewritable, but the conditional likelihood gate is not SafeStan-compatible while preserving the original model.
