# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program does not score any top-level data variable with a sampling statement; `M`, `N`, `x0`, and `X` are context inputs. Each parameter (`alpha`, `beta`, and `inv_phi`) has exactly one built-in prior sampling statement before any model-block use, and the program does not use forbidden arbitrary log-density manipulation.
