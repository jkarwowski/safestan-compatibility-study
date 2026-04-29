# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model block contains no sampling statements and does not condition on any top-level data variable; `I`, `a`, and `b` are context inputs used only for generated simulation.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The original program has no parameters, no likelihood terms, and no prohibited log-density manipulation.
