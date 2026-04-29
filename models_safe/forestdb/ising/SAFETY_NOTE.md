# SafeStan Safety Note

Compatibility: minor.

Protected data: `spin`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the elementwise likelihood so the protected top-level data variable `spin` is observed exactly once with a plain sampling statement. Added `spin_safestan_copy`, a deterministic copy of `spin`, to compute the neighbor-dependent logits without reading the protected variable before its observation. The copy in `data_safe.json` is exactly `spin_safestan_copy = spin`.
