# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model contains parameter prior sampling statements only and does not score any top-level data variable as an observation. All data variables (`M`, `N`, `x0`, and `X`) are context inputs used for deterministic computations, not protected observations.
