# SafeStan Safety Note

Compatibility: minor.

Protected data: `cases`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the likelihood `cases ~ poisson_log(r)` is unchanged and `cases` remains the only protected interface variable. The looped conditional Gaussian random-walk prior for `beta` was replaced by one equivalent built-in `multi_normal_cholesky` prior with a deterministic Cholesky factor built from `K`; `beta` is declared as a vector so it can be the plain top-level sampling target. This removes parameter-prior sampling statements from loops without changing the joint prior density. `data_safe.json` is unchanged from the supplied data.
