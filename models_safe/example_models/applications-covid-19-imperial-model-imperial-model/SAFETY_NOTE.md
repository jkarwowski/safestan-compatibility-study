# SafeStan Safety Note

Compatibility: major.

Protected data: the model conditions on the observed subset of `deaths` via country-specific slices `deaths[EpidemicStart[m] : N[m], m]`.

Generated files: none.

Reason: the likelihood is applied to ragged, indexed slices of a top-level data matrix inside a loop, and the parameter prior for `y` is also expressed elementwise inside a loop. SafeStan requires protected observations and parameter priors to be single plain top-level sampling statements outside loops. Representing this model would require changing the observed data interface to a concatenated ragged deaths vector and rebuilding the matching expected-deaths vector before a single likelihood statement, rather than a small as-is syntactic adjustment.
