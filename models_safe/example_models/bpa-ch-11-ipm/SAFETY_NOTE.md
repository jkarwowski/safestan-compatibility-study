# SafeStan Safety Note

Compatibility: major.

Protected data: `y`, `m`, and `J` are the observed data variables scored by the model likelihood.

Generated files: none.

Reason: the model cannot be translated to the SafeStan subset by a minor same-density rewrite. It defines and uses custom `_lpdf` distributions (`real_poisson_lpdf`, `real_binomial_lpdf`) with `reject()` calls for latent process terms, which SafeStan rejects. Replacing these real-valued Poisson/binomial process densities with built-in distributions would require a substantive statistical/modeling change because Stan parameters cannot be discrete integer latent variables. In addition, several parameters rely on implicit improper flat priors, and the capture-recapture likelihood scores indexed rows of `m` inside a loop rather than observing a protected top-level data variable exactly once. These issues cannot be fixed mechanically while preserving the original posterior density.
