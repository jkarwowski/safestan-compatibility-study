# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_init` and `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the indexed/looped observation statements into one top-level sampling statement for `y_init` and one top-level sampling statement for `y`. The original two indexed priors on `theta` were combined into a single vectorized built-in normal prior with deterministic transformed-data location and scale arrays. Local helper arrays are used to match the original column-specific lognormal scales for `y`. No data values were changed or added.
