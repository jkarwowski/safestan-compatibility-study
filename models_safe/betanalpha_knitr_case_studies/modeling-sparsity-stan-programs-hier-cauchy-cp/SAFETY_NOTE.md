# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two parameter prior sampling statements so that `tau` is given its prior before it is used as the scale in the prior for `theta`. This is a same-density mechanical change because the Stan log density contributions are additive and no data or model terms were changed. No data fields were added.
