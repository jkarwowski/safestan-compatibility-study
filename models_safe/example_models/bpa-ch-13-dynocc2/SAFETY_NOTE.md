# SafeStan Safety Note

Compatibility: major.

Protected data: `y` would be the modelled interface variable. `nsite` and `nyear` are context/configuration inputs.

Generated files: none.

Reason: the likelihood for `y` is a marginalized hidden Markov/dynamic occupancy likelihood implemented by a forward algorithm with manual `target += log(sum(gam[nyear]))` scoring. SafeStan forbids manual target increments, and replacing this algorithm with permitted built-in sampling statements would require a substantive model rewrite or a different likelihood representation. Therefore no same-density minor SafeStan translation is provided.
