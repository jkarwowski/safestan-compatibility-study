# SafeStan Safety Note

Compatibility: major.

Protected data: `Y`.

Generated files: none.

Reason: the observed response `Y` is the only top-level data variable scored by a likelihood statement (`Y ~ normal(mu, sigma_e)`). However, the model has top-level parameters without explicit built-in prior sampling statements: `temp_Intercept`, `beta`, and `logsigma_e`. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for these parameters would change the original posterior/log density because the original model leaves them with implicit improper priors. The looped prior for `z` could be mechanically vectorized, but the missing priors make a same-density SafeStan translation impossible without a substantive model change.
