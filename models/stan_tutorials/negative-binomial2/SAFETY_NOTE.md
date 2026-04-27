# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the protected count data `y` are observed with a plain vectorized `neg_binomial` sampling statement, but parameter `alpha` has only an implicit improper flat prior on `[0, infinity)`. SafeStan requires explicit proper priors, and adding a proper prior for `alpha` would change the posterior/log density. Therefore no same-density SafeStan translation is available as a minor mechanical rewrite.
