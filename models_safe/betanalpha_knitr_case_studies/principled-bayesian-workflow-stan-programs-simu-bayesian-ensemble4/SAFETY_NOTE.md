# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `parameters` or `model` block and does not condition on any top-level data with a sampling statement. The only data variable, `N`, is a context/configuration input used to size generated quantities. The generated-quantities RNG simulation does not introduce protected observations.
