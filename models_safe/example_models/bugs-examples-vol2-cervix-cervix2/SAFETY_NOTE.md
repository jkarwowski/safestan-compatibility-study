# SafeStan Safety Note

Compatibility: minor.

Protected data: `xc`, `dc`, `wc`, `di`, and `wi`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model observed protected data element-by-element inside loops and used parameters before their priors. The SafeStan version moves all parameter priors before parameter use, vectorizes the protected-data sampling statements so each protected top-level data variable is observed exactly once with a plain identifier on the left-hand side, and computes local helper probability/logit vectors only after the protected variables they depend on have already been observed. The `phi` prior is rewritten from elementwise loop sampling to the equivalent vectorized `phi ~ uniform(0, 1)`. No data fields or values were changed.
