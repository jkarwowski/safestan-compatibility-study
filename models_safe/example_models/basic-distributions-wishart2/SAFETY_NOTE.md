# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no data block and no observed data sampling statements.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in Wishart prior for the top-level parameter `W`, and there are no protected interface variables.
