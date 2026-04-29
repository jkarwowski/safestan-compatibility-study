# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The active `model` block contains parameter priors only; no top-level data variable is observed with a sampling statement and the apparent `map_rect` likelihood is commented out.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: removed unused function definitions, including an unused function containing `reject()` and unused user-defined log-density helpers. These functions were not called by the active transformed data, model, or generated quantities blocks and therefore did not affect the posterior/log density. Replaced the three indexed priors on `theta[1]`, `theta[2]`, and `theta[3]` with one vectorized built-in prior on the top-level parameter `theta`, preserving the same product normal density. Removed the unused local `phi` construction from the model block because it read parameters before their priors but did not affect the density. `data_safe.json` is identical to the supplied data; no deterministic copies or reshapes were added.
