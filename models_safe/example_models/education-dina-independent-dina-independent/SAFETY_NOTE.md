# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed response matrix. The other data variables (`I`, `J`, `K`, `C`, `alpha`, and `xi`) are context inputs used as sizes, attribute profiles, and mastery indicators.

Generated files: none.

Reason: the likelihood for `y` is a marginalized latent-class DINA likelihood implemented with manual `target += log_sum_exp(ps)` scoring. SafeStan forbids arbitrary `target +=` scoring and requires each protected observation to be scored exactly once by a built-in sampling statement with a plain top-level left-hand side. There is no minor mechanical built-in-distribution rewrite for this mixture likelihood; introducing latent classes, enumerating response-pattern categorical probabilities, or replacing it with independent Bernoulli terms would be a substantive model/algorithm change. The missing explicit prior for `eta` could be handled mechanically as an implicit uniform prior, but the marginalized manual likelihood still makes the model incompatible.
