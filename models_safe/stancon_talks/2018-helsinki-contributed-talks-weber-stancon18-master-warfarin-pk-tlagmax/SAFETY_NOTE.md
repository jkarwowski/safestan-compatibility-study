# SafeStan Safety Note

Compatibility: minor.

Protected data: `dv`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: `dv` remains the only protected observation. The user-defined `gamma2_overdisp` sampling statement was expanded to the equivalent built-in `gamma` likelihood with shape `mu^2 / (sigma_y^2 + mu^2 / (kappa * refSq))` and rate `mu / (sigma_y^2 + mu^2 / (kappa * refSq))`. The matrix random effect was represented by a vector parameter `Eta_vec` with a deterministic `to_matrix` transformed parameter `Eta`, so the prior has a top-level left-hand side. The componentwise prior on `theta` was rewritten as one vectorized top-level prior. The unreachable `reject()` in the lag helper was removed; for all calls in this model the lag is `inv_logit(...) * tlag_max`, while `time` is constrained to be at least `tlag_max`. Generated-quantities likelihood/RNG calculations were rewritten with built-in gamma functions. No data fields were added or changed.
