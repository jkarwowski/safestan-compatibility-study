# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the observed detection histories).

Generated files: none.

Reason: the model uses a marginalized site-occupancy likelihood with manual `target += log_sum_exp(...)` scoring for all-zero detection histories, indexed/looped observation statements for detected histories, and a constant pseudo-observation `1 ~ bernoulli_logit(...)`. Replacing this likelihood with SafeStan-compatible built-in sampling statements would require a substantive likelihood rewrite. In addition, the four real parameters have implicit improper flat priors; SafeStan requires each parameter to have exactly one built-in prior before use, and adding proper priors would change the posterior/log density.
