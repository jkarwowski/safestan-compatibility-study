# SafeStan Safety Note

Compatibility: major.

Protected data: `Y`.

Generated files: none.

Reason: the observed response `Y` is scored by the likelihood `Y ~ normal(...)`, but the model also contains a manual `target += ...` term for the random-coefficient prior involving `alpha` and `gamma`. SafeStan forbids arbitrary `target +=` scoring, and `alpha` has no built-in prior sampling statement. Replacing this determinant-based potential with SafeStan-compatible built-in sampling statements would require a substantive model/density rewrite rather than a minor mechanical translation.
