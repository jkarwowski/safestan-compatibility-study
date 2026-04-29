# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model conditions on the capture-history array `y` through a manually implemented marginalized multistate/hidden-state forward algorithm and adds the likelihood with `target += log(sum(gam[n_occasions]))`. SafeStan forbids direct `target +=` scoring, and `y` is read through indexed expressions inside the recursion rather than being observed exactly once as a top-level left-hand side of a built-in sampling statement. Replacing this likelihood with SafeStan sampling statements would require a substantive latent-state/model rewrite rather than a minor same-density translation. The implicit uniform priors on the bounded parameters could be made explicit mechanically, but the likelihood implementation remains incompatible.
