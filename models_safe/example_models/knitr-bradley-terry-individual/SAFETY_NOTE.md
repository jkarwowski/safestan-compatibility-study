# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement. The predictor/index data `K`, `N`, `player1`, and `player0` are context inputs and are not protected. The parameter `alpha` has a built-in prior before it is used in the likelihood.
