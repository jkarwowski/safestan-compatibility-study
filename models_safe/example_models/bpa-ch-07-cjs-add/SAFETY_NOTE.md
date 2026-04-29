# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the capture-history data scored by the likelihood.

Generated files: none.

Reason: the likelihood is a Cormack-Jolly-Seber capture-history likelihood assembled through data-dependent loops and conditionals using `first` and `last` values computed from `y`. The protected observation `y` is read in `transformed data` before it is scored, and its elements are later scored with indexed left-hand sides inside loops. The model also uses constant-observation sampling statements such as `1 ~ bernoulli(...)`, which SafeStan does not permit because sampling targets must be top-level protected data variables or top-level parameters. Converting this marginalized latent-state likelihood into single top-level SafeStan observations would require substantive likelihood/interface restructuring rather than a minor mechanical rewrite.
