# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The original program has no data block and no observed data likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual prior factor `target += log(z)` with the built-in prior statement `z ~ beta(2, 1) T[0.5, 1]`, which is proportional to `z` on the declared support and therefore preserves the same posterior density up to an additive constant. Added `phi ~ uniform(0, 2 * pi())`, which is density-neutral for the existing finite bounded parameter and satisfies SafeStan's unique-prior requirement. No data changes were required.
