# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Context data: `A`, `N`, and `utility` are sizes/predictors and are not protected because they are not scored as observations.

Changes: the original model computed `logits = beta * utility` before the prior statement for `beta`. SafeStan requires a parameter's prior before any model-block use of that parameter. The safe model places `beta ~ lognormal(0, 0.75)` first and inlines the same logits expression in the categorical-logit likelihood. No data changes were made; the posterior/log density is preserved.
