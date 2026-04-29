# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in uniform priors for the finite-bounded parameters `mean_lambda`, `sigma_proc`, `sigma_obs`, and `N_est1`, matching the implicit bounded uniform priors indicated by the original parameter constraints/comments. This satisfies SafeStan's requirement that every parameter have exactly one prior sampling statement before use. The parameter `lambda` already had its built-in normal prior. No data copies or reshapes were needed; `data_safe.json` is unchanged from the supplied data. `T` remains an unprotected context input.
