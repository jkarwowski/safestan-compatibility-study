# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `c ~ dirichlet(rep_vector(1, 13));` before the likelihood. This is density-neutral for a `simplex[13]` parameter because it matches the implicit uniform density on the simplex, while satisfying SafeStan's unique built-in prior requirement for parameters. No data changes were made.
