# SafeStan Safety Note

Compatibility: minor.

Protected data: `x_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: removed the unused user-defined `bridge_lpdf` and `bridge_rng` functions. The model density is unchanged because neither function was referenced by the transformed-parameter or model blocks. The protected observation `x_obs` remains a top-level data variable observed exactly once with the built-in `normal` distribution, after the prior for `xs_interior_ncp`. No data fields were added or changed; `data_safe.json` is identical to the supplied data.
