# SafeStan Safety Note

Compatibility: minor.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform` prior sampling statements for `alpha`, `beta1`, `beta2`, and `beta3` before the likelihood. These match the existing finite parameter bounds and make the originally implicit uniform priors explicit for SafeStan's unique-prior requirement. No data fields were added or changed.
