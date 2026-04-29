# SafeStan Safety Note

Compatibility: major.

Protected data: `obs_times`.

Generated files: none.

Reason: `obs_times` is the observed variable scored by the likelihood, but it is scored through `target += sub_lpdf(obs_times[n] | gamma1, gamma2)` inside a loop. SafeStan forbids manual `target +=` scoring and `_lpdf` user-defined distribution functions/calls. The custom `sub_lpdf` density is not a built-in Stan distribution, so replacing it with SafeStan sampling statements would require a substantive likelihood/model rewrite rather than a minor same-density translation.
