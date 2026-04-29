# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added an explicit `sigma_y ~ uniform(0, 2.5)` prior before `sigma_y` is used in the likelihood. This matches the existing finite bounds on `sigma_y` and makes the implicit proper bounded-uniform prior explicit for SafeStan's unique-prior requirement. No data changes were required. `N` is a size and `movie` is an index/predictor, so they are not protected.
