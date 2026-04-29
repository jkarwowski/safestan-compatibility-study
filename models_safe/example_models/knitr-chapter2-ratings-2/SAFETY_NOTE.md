# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added an explicit `sigma_y ~ uniform(0, 2.5);` prior before `sigma_y` is used in the likelihood. This matches the finite bounded support already declared for `sigma_y` and satisfies SafeStan's requirement that every parameter have exactly one built-in prior sampling statement before use. The data are unchanged. `N`, `J`, and `movie` are context inputs, not protected observations.
