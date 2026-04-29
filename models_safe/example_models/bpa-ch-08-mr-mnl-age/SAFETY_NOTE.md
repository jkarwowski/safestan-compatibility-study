# SafeStan Safety Note

Compatibility: major.

Protected data: `marr_j` and `marr_a` are the observed m-array count data scored by the multinomial likelihood, row by row.

Generated files: none.

Reason: the likelihood is a data-dependent product of multinomial sampling statements inside a loop with indexed left-hand sides (`marr_j[t]` and `marr_a[t]`). SafeStan requires each protected observation to be scored exactly once as a plain top-level identifier and forbids protected-data sampling inside loops. An exact general rewrite would require either a built-in vectorized array-of-multinomials likelihood or unrolling a data-dependent number of top-level protected row variables; alternative flattening or Poisson/categorical rewrites would change the normalized log-likelihood by data-dependent constants. Adding explicit uniform priors for the bounded parameters would be minor, but it does not resolve the protected-likelihood issue.
