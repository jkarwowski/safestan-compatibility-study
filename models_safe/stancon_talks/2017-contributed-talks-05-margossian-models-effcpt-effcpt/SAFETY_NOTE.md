# SafeStan Safety Note

Compatibility: minor.

Protected data: `cObs`, `respObs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: removed the transformed-data observation `logCObs = log(cObs)` and replaced `logCObs ~ normal(log(cHatObs), sigma)` with the built-in normalized observation statement `cObs ~ lognormal(log(cHatObs), sigma)`. This makes the observed concentration vector itself a top-level protected variable and avoids reading protected data before observation. The response likelihood was already a valid top-level protected-data sampling statement. The data file is unchanged.
