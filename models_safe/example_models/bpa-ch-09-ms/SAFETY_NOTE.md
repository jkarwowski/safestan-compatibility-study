# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized multi-state capture-recapture / hidden-state model implemented by a forward algorithm with manual `target += log(sum(gamma[n_occasions]))` scoring. SafeStan forbids arbitrary `target +=` scoring and requires each protected data variable to be observed exactly once with a built-in sampling statement. Replacing this algorithm with SafeStan-compatible sampling would require a substantive likelihood/model rewrite rather than a minor same-density translation.
