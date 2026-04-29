# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores `log_earnings`, a transformed-data quantity computed as `log(earnings)`, so the observed interface is derived from top-level data `earnings`.

Generated files: none.

Reason: the likelihood is applied to a transformed-data variable rather than a plain top-level data identifier, which would require introducing a protected top-level transformed observation. More importantly, the parameters `alpha`, `beta`, and `sigma` have no explicit priors in the original model. SafeStan requires each parameter to have exactly one built-in prior before use, and adding proper priors here would change the posterior/log density. Therefore this cannot be translated with only a minor same-density rewrite.
