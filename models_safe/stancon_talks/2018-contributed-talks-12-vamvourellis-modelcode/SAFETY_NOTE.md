# SafeStan Safety Note

Compatibility: minor.

Protected data: `yc` and `yb_safestan_flat`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: flattened `zb` for a single top-level normal prior, scored protected `yc` and `yb_safestan_flat` with top-level vectorized likelihoods, rebuilt local latent vectors after observing `yc`, and corrected synthetic `K` to `Kc + Kb`.
