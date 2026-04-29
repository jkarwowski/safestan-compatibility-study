# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed capture-history array modelled by the likelihood.

Generated files: none.

Reason: the likelihood is a marginalized latent-state/forward-algorithm computation implemented with `target += log(sum(gamma[n_occasions]))`, with observation values also inspected through indexing and in `transformed data` to compute first-capture occasions. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing this forward algorithm with SafeStan-compatible sampling statements would require a substantive model rewrite or a different likelihood representation, not a minor same-density translation.
