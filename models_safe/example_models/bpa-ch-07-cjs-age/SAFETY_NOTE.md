# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_bernoulli_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_bernoulli_safestan` and `n_bernoulli_safestan`. The new protected vector is a deterministic list, in the original likelihood order, of the Bernoulli outcomes scored by the model: for each scored survival or terminal `1` outcome it copies the individual's last-capture entry of `y` (which is 1), and for each recapture term it copies the corresponding `y[i, t]`. For the supplied data this gives `[1, 0, 1, 1, 1, 0, 1, 1, 1]`. The original `y` is retained as context for computing first/last capture indices and the deterministic ordering of the probability vector. The looped/indexed likelihood statements were replaced by one vectorized Bernoulli sampling statement using precomputed probabilities. Added explicit `uniform(0, 1)` priors for the bounded parameters `mean_p` and `beta`, matching the original implicit uniform priors.
