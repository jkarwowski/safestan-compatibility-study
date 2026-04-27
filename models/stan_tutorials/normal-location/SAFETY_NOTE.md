# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes `y`, which is constructed in `transformed data`; moving the fixed values to top-level data would be a mechanical change. However, the parameter `mu` has no explicit proper prior, corresponding to an implicit improper flat prior on an unconstrained real parameter. SafeStan requires explicit proper priors, and adding one would change the posterior/log density. Therefore no same-density SafeStan translation is available.
