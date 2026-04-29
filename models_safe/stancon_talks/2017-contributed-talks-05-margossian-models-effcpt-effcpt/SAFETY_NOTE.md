# SafeStan Safety Note

Compatibility: minor.

Protected data: `logCObs` and `respObs`. `logCObs` is the modelled log-concentration observation from the original transformed-data assignment `logCObs = log(cObs)`; `respObs` is the original response observation.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: promoted `logCObs` from transformed data to a top-level data variable so it can be observed with a SafeStan plain sampling statement. In `data_safe.json`, `logCObs[i] = log(cObs[i])` was computed deterministically from the supplied original `cObs`; all other retained data are copied unchanged. The likelihood terms and parameter priors are otherwise unchanged, and each protected variable and each parameter is scored exactly once by a built-in distribution outside loops.
