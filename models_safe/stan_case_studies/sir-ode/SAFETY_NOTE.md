# SafeStan Safety Note

Compatibility: minor.

Protected data: `stoi`, `B`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so the parameter priors for `beta`, `gamma`, `xi`, and `delta` occur before any model-block use of the transformed parameter `y` through `y_diff`. This preserves the same posterior/log density because the log-density contributions are only reordered. The data file is unchanged.
