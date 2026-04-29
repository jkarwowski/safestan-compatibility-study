# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation histories `y` are scored through a marginalized hidden-state forward algorithm implemented with manual `target += log(sum(gamma[n_occasions]))`. SafeStan forbids arbitrary `target +=` scoring and requires each protected data variable to be observed exactly once by a built-in distribution sampling statement. Replacing this forward-algorithm likelihood with SafeStan sampling statements would require a substantive model rewrite and would not be a minor same-density translation. The model also reads `y` in `transformed data` to compute first-capture occasions before any SafeStan observation statement could occur.
