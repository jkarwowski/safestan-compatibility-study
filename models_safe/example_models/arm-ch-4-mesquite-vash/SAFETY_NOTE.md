# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `log_weight`, a transformed-data quantity computed as `log(weight)`. SafeStan protected variables must be top-level data variables, so no protected-variable list is emitted for generated files.

Generated files: none.

Reason: a same-density SafeStan rewrite would have to make the transformed response `log_weight` a top-level protected observation, or replace the likelihood with one directly on `weight`; the latter changes the normalized likelihood by a Jacobian term, and the former is not a simple deterministic copy/reshape of the supplied data interface. In addition, parameters `alpha`, `beta`, and `sigma` are used in the likelihood without prior sampling statements. Adding proper built-in priors would change the original posterior/log density, which uses implicit improper flat priors. Therefore this is not a minor SafeStan translation.
