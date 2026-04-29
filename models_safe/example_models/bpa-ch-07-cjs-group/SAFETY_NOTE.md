# SafeStan Safety Note

Compatibility: major.

Protected data choice: the capture-history array `y` is the natural protected interface because elements of `y` are scored in the model likelihood.

Generated files: none.

Reason: the model is not representable in the SafeStan subset by a minor mechanical rewrite. The likelihood scores indexed elements `y[i, t]` inside data-dependent loops, while `y` is also read in `transformed data` to compute `first` and `last` and then used to gate which likelihood factors are applied. SafeStan requires protected data to be scored exactly once as a plain top-level identifier before any other use. The model also contains likelihood factors written as literal observations, `1 ~ bernoulli(...)`, for survival and terminal non-capture terms; making these SafeStan observations would require introducing new protected pseudo-data not present as deterministic copies or reshapes of the supplied data. Replacing the Cormack-Jolly-Seber marginalized capture-history likelihood with flattened pseudo-observations or another normalized representation would be a substantive likelihood rewrite rather than a minor same-density translation.
