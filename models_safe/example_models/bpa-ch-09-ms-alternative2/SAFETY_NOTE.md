# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model scores the capture-history observations `y` with a custom marginalized hidden-state forward algorithm using `target += log(sum(gamma[n_occasions]))`. SafeStan forbids manual `target +=` scoring, and the protected observation is also inspected/indexed to compute `first` before any possible SafeStan observation statement. Replacing this with SafeStan-compatible built-in sampling statements would require a substantive latent-state/HMM likelihood rewrite rather than a minor same-density translation. The other data variables, `nind` and `n_occasions`, are sizes/context inputs and are not protected observations.
